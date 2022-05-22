-- Function: zfCalc_UserMain_1

DROP FUNCTION IF EXISTS zfCalc_UserMain_1();

CREATE OR REPLACE FUNCTION zfCalc_UserMain_1()
RETURNS Integer
AS
$BODY$
BEGIN
     
     RETURN (139
           /*SELECT MIN (Object.Id)
             FROM Object
                  JOIN ObjectBoolean AS OB_User_Sign
                                     ON OB_User_Sign.ObjectId  = Object.Id
                                    AND OB_User_Sign.DescId    = zc_ObjectBoolean_User_Sign()
                                    AND OB_User_Sign.ValueData = TRUE
             WHERE Object.DescId = zc_Object_User()*/
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.22                                        *
*/

-- тест
-- SELECT * FROM Object WHERE Id = zfCalc_UserMain_1()
