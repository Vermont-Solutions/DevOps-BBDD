CREATE OR REPLACE PACKAGE HR.hr_test AS
  -- %suite(HR Suite) 

  -- %test(Add Job History Test) 
  PROCEDURE add_job_history_test;

END;
/



CREATE OR REPLACE PACKAGE BODY HR.hr_test AS
  PROCEDURE add_job_history_test AS
    l_employee_id     job_history.employee_id%type := 100;  -- Ejemplo de ID de empleado
    l_start_date      job_history.start_date%type := TO_DATE('2000-01-01', 'YYYY-MM-DD');  -- Ejemplo de fecha de inicio
    l_end_date        job_history.end_date%type   := TO_DATE('2002-12-31', 'YYYY-MM-DD');  -- Ejemplo de fecha de finalización
    l_job_id          job_history.job_id%type     := 'AC_ACCOUNT';  -- Ejemplo de ID de trabajo
    l_department_id   job_history.department_id%type := 110;  -- Ejemplo de ID de departamento
    l_record          job_history%ROWTYPE;
  BEGIN
    -- Ejecutar el procedimiento que se está probando
    hr.add_job_history(l_employee_id, l_start_date, l_end_date, l_job_id, l_department_id);

    -- Recuperar el registro que se acaba de insertar
    SELECT *
    INTO   l_record
    FROM   job_history
    WHERE  employee_id = l_employee_id
    AND    start_date = l_start_date;

    -- Comprobar que los datos correctos han sido insertados en la tabla
    ut.expect(l_record.end_date).to_equal(l_end_date);
    ut.expect(l_record.job_id).to_equal(l_job_id);
    ut.expect(l_record.department_id).to_equal(l_department_id);
  END;

END;
/

