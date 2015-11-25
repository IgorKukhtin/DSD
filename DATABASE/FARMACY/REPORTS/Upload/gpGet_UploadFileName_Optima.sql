-- Function: gpGet_UploadFileName_Optima ()

DROP FUNCTION IF EXISTS gpGet_UploadFileName_Optima (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UploadFileName_Optima(
    IN inDate            TDateTime , --дата выгрузки
    IN inObjectId        Integer   , --Поставщик
    IN inUnitId          Integer   , --подразделение
   OUT outFileName       TVarChar  , -- Имя файла
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
    DECLARE vbUnitCode TVarChar;
BEGIN
    Select 
        Object_ImportExportLink.StringKey AS DeliveryCode
    INTO
        vbUnitCode
    FROM Object_ImportExportLink_View AS Object_ImportExportLink
        Inner Join Object ON Object_ImportExportLink.MainId = Object.ID
                         AND Object.DescId = zc_Object_Unit()
    WHERE
        Object_ImportExportLink.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
        AND
        Object_ImportExportLink.ValueId = inObjectId
        AND
        Object_ImportExportLink.MainId = inUnitId;
    outFileName := 'Report_'||COALESCE(vbUnitCode,'')||'_'||TO_CHAR(inDate,'YYYYMMDD');
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_UploadFileName_Optima (TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 25.11.15                                                                        *
*/

