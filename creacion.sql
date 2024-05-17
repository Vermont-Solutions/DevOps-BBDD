CREATE OR REPLACE PROCEDURE PA_Inserta_Polizas_Col(pPeriodo VARCHAR2, pEstado VARCHAR2, pBase VARCHAR2,
 oError IN OUT VARCHAR2) IS --, pCProc NUMBER, pSID NUMBER ) IS
 vCProc NUMBER;
 vSID NUMBER;

CURSOR C_Busca_Polizas IS
 SELECT pol_cod_poli Poliza, rowid registro
 FROM res_tab_polc
 WHERE pol_per_res = pPeriodo
 AND pol_cod_est = pEstado
 AND pol_cod_base = pBase;

 vPerUPP VARCHAR2(6); --- Ultimo Periodo de Pago( Devengado )
 vPerPCB VARCHAR2(6); --- Periodo Cobro
 vMeses NUMBER; --- Meses de Cobro
 vFecUPP DATE; --- Fecha Ultima de Pago
 vFecPPP DATE; --- Fecha Prsxima de Pago
 --    WHERE  ROWID     = reg.registro ;
 --           a.ROWID                                  Registro

BEGIN
 Pa_Inserta_Proceso( vCProc , vSID , 'Inserta Pólizas Colectivo Periodo: '||pPeriodo || ' Base: '||pBase);
 Pa_Actualiza_Proceso( vCProc , vSID , 'Eliminando para periodo: '||pPeriodo ||' Estado: ' || pEstado||' '||TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss'), NULL);
 DELETE RES_TAB_POLC
 WHERE POL_PER_RES = pPeriodo
 AND POL_COD_EST = pEstado
 AND POL_COD_BASE = pBase
-- and pol_cod_poli in ( '490000120','490000103','490000107')
 --AND POL_COD_POLI <> '012'
 --AND POL_COD_POLI = '340000149'
 AND SUBSTR(POL_COD_POLI,1,2) <> '50'
 ;
 COMMIT;
 Pa_Actualiza_Proceso( vCProc , vSID , 'Pólizas Colectivos para periodo: '||pPeriodo ||' Estado: ' || pEstado||' '||
  TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss'), NULL);
 INSERT INTO RES_TAB_POLC (
 POL_PER_RES
 , POL_COD_EST
 , POL_COD_BASE
 , POL_COD_POLI
 , POL_FEC_VIGE
 , POL_FEC_VCTO
 , POL_NRO_RENOV
 , POL_FEC_RENOV
 , POL_COD_MNDA
 , POL_COD_FPAG_ORIG
 , POL_COD_FPAG
 , POL_RUT_CONT
 , POL_RUT_CORR
 , POL_COD_LNEG
 )
 --
 SELECT pPeriodo periodo,
 pEstado Estado,
 pBase Base,
 p.POLIZA poliza,
 r0.VIGDESDEREN iniciopoliza,
 r.VIGHASTAREN vigenciahasta,
 r.renovacion,
 r.VIGDESDEREN fec_renov,
 p.MONEDA moneda,
 p.PERIODOCOBRO,
 DECODE(p.PERIODOCOBRO,'M','1', --Mensual
 'T','2', --Trimestral
 'S','3', --Semestral
 'A','4', --Anual
 'U','5', --Unico
 'B','6', --Bimestral
 'C','7', --Cuatrimestral
 'N', '4' --es Anual con vigencia por asegurado
 ) formapago,
 p.rutcontratante contratante,
 p.CORREDOR corredor,
 LINEANEGOCIO
 FROM ifw_polizas p,
 --
 (SELECT POLIZA
 , RENOVACION
 , VIGDESDEREN
 , VIGHASTAREN
 FROM ifw_renovaciones r
 WHERE (R.POLIZA , r.RENOVACION ) IN ( SELECT R1.POLIZA , MAX(R1.RENOVACION)
 FROM ifw_renovaciones R1
 WHERE R1.POLIZA = R.POLIZA
 AND TO_CHAR(r1.VIGDESDEREN,'YYYYMM') <= pPeriodo
 AND TO_CHAR(r1.VIGHASTAREN,'YYYYMM') >= pPeriodo
 GROUP BY R1.POLIZA )
 ) r,
 --
 ( SELECT poliza, VIGDESDEREN
 FROM ifw_renovaciones
 WHERE renovacion = 0
 ) r0
 WHERE p.poliza=r.poliza
 AND p.poliza=r0.poliza
 AND TO_CHAR(r.VIGDESDEREN,'YYYYMM') <= pPeriodo
 AND TO_CHAR(r.VIGHASTAREN,'YYYYMM') >= pPeriodo
 AND p.poliza <> '340000206'
 and P.poliza <> '340004856'
 AND NVL(p.lineanegocio,0) <> 5
 AND SUBSTR(P.poliza,1,2) <> '50'
 and p.poliza not in (SELECT distinct b.pol_cod_poli --h.poliza
                                                 from res_tab_pold b
                                                 where b.pol_cod_poli = p.poliza
                                                 AND b.pol_grupo = 'OTRAS'
                                                 AND b.pol_cod_fpag = 'U'
                                                 AND b.pol_cod_base = pBase)

 ;
 COMMIT;
 Pa_Actualiza_Proceso (vCProc, vSID,'Actualizando Estado de la Base/Periodo'||' '||TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss') ,SYSDATE) ;
 UPDATE Res_tab_PBas
 SET PBAS_FEC_SVT = SYSDATE
 WHERE PBAS_PER_RES = pPeriodo
 AND PBAS_COD_BASE = 'COL' ;
 COMMIT;
---actualiza proximo devengo
 Pa_Actualiza_Proceso (vCProc, vSID,'Actualizando Datos Proximo Devengo'||' '||TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss') ,SYSDATE) ;
 For Pc in C_Busca_Polizas Loop
 Begin
-- CCP propuesta 21 marzo 2016
   SELECT to_char(abs(to_number(max(anomes))))
   INTO vPerUPP
   FROM ifw_primasporgrupo
   WHERE poliza = to_number(Pc.Poliza);
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     vPerUPP := null;
   End;
 ---
   IF vPerUPP is not null THEN
       Begin
 -- se propone
        SELECT a.Periodocobro, b.meses
        INTO vPerPCB, vMeses
        FROM res_tmp_ifw_polizas a, ifw_tipoperiodicidadcobro b
        WHERE a.poliza = to_number(Pc.Poliza)
        AND a.periodocobro = b.periodocobro;
        Exception
        when others then
          vPerPCB:=null; vMeses:=0;
        End;
 ---
 ---- Calculamos El prsximo Permodo de Devengo
 ---
       IF vMeses < 0 Then
          vMeses := 0;
       END IF;
 ---
       vFecPPP := add_months(to_date(vPerUPP, 'YYYYMM'),vMeses);
 ---
       vFecUPP := to_date(vPerUPP, 'YYYYMM');

-- propuesta CCP 21 marzo 2016
     UPDATE res_tab_polc
     SET POL_FEC_UPP = vFecUPP,
         POL_FEC_PPP = vFecPPP
      WHERE  ROWID     = Pc.registro ;

 End IF;
 End Loop;
 COMMIT;
 Pa_Actualiza_Proceso( vCProc , vSID , 'Finalizado sin errores'||' '||TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss'), SYSDATE);
EXCEPTION
 WHEN OTHERS THEN
 oERROR := 'Al insertar Pólizas, para el periodo '||pPERIODO||' se ha producido el error '||SQLERRM;
 Pa_Actualiza_Proceso( vCProc , vSID , oERROR, SYSDATE);
END;
