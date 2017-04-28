-- Function: lfGet_User_BillNumberMobile (Integer)

DROP FUNCTION IF EXISTS lfGet_User_BillNumberMobile (Integer);

CREATE OR REPLACE FUNCTION lfGet_User_BillNumberMobile(
    IN inUserId       Integer
)
RETURNS Integer
AS
$BODY$
BEGIN

     -- своя нумерация документов
     RETURN COALESCE ((SELECT ObjectFloat.ValueData
                       FROM ObjectFloat
                       WHERE ObjectFloat.DescId   = zc_ObjectFloat_User_BillNumberMobile()
                         AND ObjectFloat.ObjectId = inUserId), 0) :: Integer;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_User_BillNumberMobile (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.17                                        *
*/

-- тест
-- SELECT * FROM lfGet_User_BillNumberMobile (5)
