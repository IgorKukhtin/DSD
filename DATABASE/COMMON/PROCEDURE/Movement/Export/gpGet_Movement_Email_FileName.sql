-- Function: gpGet_Movement_Email_FileName(Integer, TVarChar)

-- DROP FUNCTION IF EXISTS gpGet_Movement_XML_FileName (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Email_FileName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Email_FileName(
   OUT outFileName            TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   ,
   OUT outExportType          TVarChar  ,
   OUT outExportKindId        Integer   ,
    IN inMovementId           Integer   ,
    IN inSession              TVarChar
)
  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     SELECT tmp.outFileName, tmp.outDefaultFileExt, tmp.outEncodingANSI, tmp.outExportType, tmp.outExportKindId
            INTO outFileName, outDefaultFileExt, outEncodingANSI, outExportType, outExportKindId
     FROM
    (WITH tmpExportJuridical AS (SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId FROM lpSelect_Object_ExportJuridical_list() AS tmp)
          -- Недавній ФОП- формат XLS
        , tmpExport_XLS AS (SELECT DISTINCT 0 AS PartnerId, tmp.ExportKindId FROM lpSelect_Object_ExportJuridical_list() AS tmp WHERE tmp.Id = 7448983 LIMIT 1)
          --
        , tmpProtocol_all AS (SELECT MovementProtocol.Id, MovementProtocol.OperDate FROM MovementProtocol WHERE MovementProtocol.MovementId = inMovementId)
        , tmpProtocol AS (SELECT tmpProtocol_all.OperDate FROM tmpProtocol_all ORDER BY tmpProtocol_all.Id LIMIT 1)

     SELECT CASE WHEN tmpExportJuridical.ExportKindId = zc_Enum_ExportKind_Mida35273055()

                      THEN COALESCE (ObjectString_GLNCode.ValueData, '')
                 || '_' || REPLACE (zfConvert_DateShortToString (MovementDate_OperDatePartner.ValueData), '.', '')
                 || '_' || Movement.InvNumber

                 -- Avion
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Avion40110917())
                      THEN COALESCE (REPLACE (Object_JuridicalBasis.ValueData, '"', ''), 'Alan')
                 || '_' || Movement.InvNumber
                 || '_' || REPLACE (REPLACE (COALESCE (Object_Juridical.ValueData, 'Юр_лицо') || ' №' || COALESCE (ObjectString_RoomNumber.ValueData, '0'), '"', ''), '/', '_')


                 -- Vez+Brusn
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Vez37171990(), zc_Enum_ExportKind_Brusn34604386())
                      THEN COALESCE (REPLACE (Object_JuridicalBasis.ValueData, '"', ''), 'Alan')
                 || '_' || Movement.InvNumber
                 || '_' || COALESCE (Object_Retail.ValueData, 'Торговая сеть') || ' №' || CASE WHEN tmpExportJuridical.ExportKindId = zc_Enum_ExportKind_Brusn34604386()
                                                                                                    THEN Object_Partner.Id :: TVarChar -- COALESCE (ObjectString_RoomNumber.ValueData, '0')
                                                                                               ELSE COALESCE (ObjectString_RoomNumber.ValueData, '0')
                                                                                          END
                 -- Dakort
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Dakort39135074())
                      THEN COALESCE (REPLACE (REPLACE (Object_JuridicalBasis.ValueData, '"', ''), '/', '_'), 'Alan')
                 || '_' || Movement.InvNumber
                 --|| '_' || COALESCE (Object_Retail.ValueData, 'Торговая сеть') || ' №' || CASE WHEN tmpExportJuridical.ExportKindId = zc_Enum_ExportKind_Brusn34604386()
                 --                                                                                   THEN Object_Partner.Id :: TVarChar -- COALESCE (ObjectString_RoomNumber.ValueData, '0')
                 --                                                                              ELSE COALESCE (ObjectString_RoomNumber.ValueData, '0')
                 --                                                                         END
                 --|| '_' || zfConvert_DateShortToString (MovementDate_OperDatePartner.ValueData)
                 -- || '.csv'
                 
                 -- Glad
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Glad2514900150())
                      THEN 'Zakaz'
                 || '_' || '1024'
                 || '_' || zfConvert_DateTimeToStringY (COALESCE (tmpProtocol.OperDate, CURRENT_TIMESTAMP) :: TDateTime)
                 || '_' || Movement.InvNumber

                 -- Logistik + Nedavn
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Logistik41750857(), zc_Enum_ExportKind_Nedavn2244900110())
                      THEN 'Doc_Alan'
                 || '_' || zfCalc_Text_replace (zfConvert_DateShortToString (MovementDate_OperDatePartner.ValueData), '.', '_')
                 || '_' || Movement.InvNumber

                 -- Таврия+
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Tavr31929492())
                      THEN COALESCE (REPLACE (Object_JuridicalBasis.ValueData, '"', ''), 'Alan')
--               || '_' || Movement.InvNumber
--               || '_' || COALESCE (Object_Juridical.ValueData, 'Юр_лицо') || ' №' || COALESCE (ObjectString_RoomNumber.ValueData, '0')
                 || ' № ' || Movement.InvNumber
                 || ' - ' || REPLACE (REPLACE (COALESCE (Object_Partner.ValueData, Object_Juridical.ValueData, 'Юр_лицо'), '"', ''), '/', '_')
                 
                 -- !!!
                 WHEN tmpExportJuridical.PartnerId IS NULL
                      THEN 'Doc_Alan'
                 || '_' || zfCalc_Text_replace (zfConvert_DateShortToString (MovementDate_OperDatePartner.ValueData), '.', '_')
                 || '_' || Movement.InvNumber

            END AS outFileName

          , CASE WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Mida35273055(), zc_Enum_ExportKind_Brusn34604386(), zc_Enum_ExportKind_Glad2514900150())
                      THEN 'xml'
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Vez37171990(), zc_Enum_ExportKind_Dakort39135074(), zc_Enum_ExportKind_Avion40110917())
                      THEN 'csv'
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Logistik41750857(), zc_Enum_ExportKind_Nedavn2244900110())
                      THEN 'xls'
                    --THEN 'xlsx'  
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Tavr31929492())
                      THEN '.txt'

                 -- !!!
                 WHEN tmpExportJuridical.PartnerId IS NULL
                      THEN 'xls'

            END AS outDefaultFileExt

          , CASE WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Mida35273055(), zc_Enum_ExportKind_Brusn34604386(), zc_Enum_ExportKind_Glad2514900150())
                      THEN FALSE
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Vez37171990(), zc_Enum_ExportKind_Dakort39135074(), zc_Enum_ExportKind_Avion40110917(), zc_Enum_ExportKind_Tavr31929492())
                      THEN TRUE
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Logistik41750857(), zc_Enum_ExportKind_Nedavn2244900110())
                      THEN FALSE

                 -- !!!
                 WHEN tmpExportJuridical.PartnerId IS NULL
                      THEN FALSE

            END AS outEncodingANSI
            
          , CASE WHEN tmpExportJuridical.ExportKindId = zc_Enum_ExportKind_Glad2514900150()
                      THEN 'cxegExportToTextUTF8'
                 WHEN tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Logistik41750857(), zc_Enum_ExportKind_Nedavn2244900110())
                      THEN 'cxegExportToExcel'

                 -- !!!
                 WHEN tmpExportJuridical.PartnerId IS NULL
                      THEN 'cxegExportToExcel'

                 ELSE 'cxegExportToText'

            END AS outExportType

          , COALESCE (tmpExportJuridical.ExportKindId, tmpExport_XLS.ExportKindId) :: Integer AS outExportKindId
            
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                               ON ObjectLink_Contract_JuridicalDocument.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                              AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                               ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
          LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId, ObjectLink_Contract_JuridicalBasis.ChildObjectId)

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementLinkObject_To.ObjectId ELSE MovementLinkObject_From.ObjectId END
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                 ON ObjectString_RoomNumber.ObjectId = Object_Partner.Id
                                AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()
                                AND ObjectString_RoomNumber.ValueData <> ''
          LEFT JOIN ObjectString AS ObjectString_GLNCode
                                 ON ObjectString_GLNCode.ObjectId = Object_Partner.Id
                                AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
          --
          LEFT JOIN tmpExportJuridical ON tmpExportJuridical.PartnerId = Object_Partner.Id
          LEFT JOIN tmpExport_XLS ON 1=1
          --
          LEFT JOIN tmpProtocol ON 1=1
     WHERE Movement.Id = inMovementId) AS tmp
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.11.22         * add zc_Enum_ExportKind_Tavr31929492
 23.03.16                                        *
 25.02.16                                        *
*/


-- тест
-- SELECT * FROM gpGet_Movement_Email_FileName (inMovementId:= 3376510, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
-- SELECT * FROM gpGet_Movement_Email_FileName (inMovementId:= 3252496, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Vez37171990()
-- SELECT * FROM gpGet_Movement_Email_FileName (inMovementId:= 3438890, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Brusn34604386()
-- SELECT * FROM gpGet_Movement_Email_FileName (inMovementId:= 15595974, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Glad2514900150()
-- SELECT * FROM gpGet_Movement_Email_FileName (inMovementId:= 17125578, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Avion40110917()
-- SELECT * FROM gpGet_Movement_Email_FileName (inMovementId:= 21640170, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Nedavn2244900110()
-- SELECT * FROM gpGet_Movement_Email_FileName (inMovementId:= 23921479, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Tavr31929492()
