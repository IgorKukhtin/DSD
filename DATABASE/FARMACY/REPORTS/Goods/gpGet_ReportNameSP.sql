-- Function: gpGet_ReportNameSP()

DROP FUNCTION IF EXISTS gpGet_ReportNameSP (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_ReportNameSP (
    IN inJuridicalId         Integer  , -- 
    IN inPartnerMedicalId    Integer  , -- 
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

       -- Результат 
       -- не зависит от нашего юр.лица
       SELECT COALESCE (PrintForms_View.PrintFormName, 'Отчет по продажам Соц.проекта')
              INTO vbPrintFormName
       FROM PrintForms_View
       WHERE PrintForms_View.PartnerMedicalId = inPartnerMedicalId
         AND PrintForms_View.ReportType = 'Report_Check_SP';

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.02.18         *
*/

-- тест
-- SELECT * FROM gpGet_ReportNameSP (inJuridicalId:= 0, inPartnerMedicalId:= 3690583, inSession:= '5'); -- test
-- SELECT * FROM gpGet_ReportNameSP (inJuridicalId:= 0, inPartnerMedicalId:= 4474508, inSession:= '5'); -- раб.