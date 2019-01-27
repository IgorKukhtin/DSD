-- Function: gpGet_GlobalConst_SiteDiscount

DROP FUNCTION IF EXISTS gpGet_GlobalConst_SiteDiscount (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GlobalConst_SiteDiscount(
    IN     inSession          TVarChar  -- Сессия пользователя
)
RETURNS TFloat
AS
$BODY$
BEGIN
     
     IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = zc_Enum_GlobalConst_SiteDiscount() AND OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_GlobalConst_SiteDiscount())
     THEN
         -- Результат
         RETURN ((SELECT 1 FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_GlobalConst_SiteDiscount() AND OFl.DescId = zc_ObjectFloat_GlobalConst_SiteDiscount()));
     ELSE
         -- Результат
         RETURN (0);
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.19                                        *
*/

-- тест
-- SELECT gpGet_GlobalConst_SiteDiscount (inSession:= zfCalc_UserAdmin())
