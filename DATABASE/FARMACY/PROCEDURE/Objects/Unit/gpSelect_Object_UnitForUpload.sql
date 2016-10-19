-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForUpload(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForUpload(
    IN inObjectId    integer,       -- Юрлицо поставщик
    IN inSelectAll   Boolean,       -- выделить все подразделения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (NeedUpload Boolean, UnitId Integer, UnitCode Integer, UnitCodePartner TVarChar, UnitName TVarChar) 
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
    RETURN QUERY 
    SELECT inSelectAll       as NeedUpload
         , Object.Id         as UnitId
         , Object.ObjectCode as UnitCode
         , Object_ImportExportLink.StringKey as UnitCodePartner
         , Object.ValueData  as UnitName
    FROM Object_ImportExportLink_View AS Object_ImportExportLink
        Inner Join Object ON Object_ImportExportLink.MainId = Object.ID
                         AND Object.DescId = zc_Object_Unit()
    WHERE
        Object_ImportExportLink.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
        AND
        Object_ImportExportLink.ValueId = inObjectId
    ORDER BY CASE WHEN Object.Id = 2144918 THEN 0 ELSE 1 END
   ;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UnitForUpload(Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А
 25.11.15                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitForUpload (inObjectId:= 59611, inSelectAll:= NULL, inSession:= '3')
