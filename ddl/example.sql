-- Creación de un procedimiento almacenado para sumar dos números
CREATE OR REPLACE PROCEDURE AddNumbers (
    num1 IN NUMBER,
    num2 IN NUMBER,
    result OUT NUMBER
) IS
BEGIN
    -- Realiza la suma de los dos números
    result := num1 + num2;
    
    -- Manejo de errores
    EXCEPTION
        WHEN OTHERS THEN
            -- En caso de error, se puede manejar el error aquí
            RAISE_APPLICATION_ERROR(-20001, 'Error en la operación de suma: ' || SQLERRM);
END;
/
