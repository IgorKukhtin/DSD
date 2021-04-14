-- Function: gpSelect_ReportCollation_byUser()

DROP FUNCTION IF EXISTS gpSelect_ReportCollation_byUser (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReportCollation_byUser(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ObjectCode Integer, idBarCode TVarChar, BarCode_Sale TVarChar
             , StartDate  TDateTime
             , EndDate    TDateTime
             , JuridicalName TVarChar
             , PartnerName TVarChar
             , ContractName TVarChar
             , PaidKindName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , BuhName TVarChar
             , BuhDate TDateTime
             , isBuh Boolean
             , isDiff Boolean

              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId_user  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Определяется <Физическое лицо> - кто сформировал визу inReestrKindId
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- Проверка
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN 
         RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
     END IF;


   -- Результат
   RETURN QUERY 
   WITH
     -- выбираем за период для Одного пользователя
     tmpReport AS (SELECT ObjectDate_Buh.ObjectId      AS Id
                        , ObjectLink_Buh.ChildObjectId AS BuhId
                        , ObjectDate_Buh.ValueData     AS BuhDate
                   FROM ObjectDate AS ObjectDate_Buh
                        INNER JOIN ObjectLink AS ObjectLink_Buh
                                ON ObjectLink_Buh.ObjectId = ObjectDate_Buh.ObjectId
                               AND ObjectLink_Buh.DescId = zc_ObjectLink_ReportCollation_Buh()
                               AND (ObjectLink_Buh.ChildObjectId = vbMemberId_user)
                   WHERE ObjectDate_Buh.DescId = zc_ObjectDate_ReportCollation_Buh()
                     AND ObjectDate_Buh.ValueData >= inStartDate AND ObjectDate_Buh.ValueData < inEndDate + INTERVAL '1 DAY'
                   )
      , tmpData AS (SELECT
                          tmpReport.Id
                        , Object_ReportCollation.ObjectCode
                        , (zfFormat_BarCode (zc_BarCodePref_Object(), tmpReport.Id) || '0') ::TVarChar AS idBarCode
                        , ObjectDate_Start.ValueData      AS StartDate
                        , ObjectDate_End.ValueData        AS EndDate
                        , Object_Juridical.ValueData      AS JuridicalName
                        , Object_Partner.ValueData        AS PartnerName
                        , Object_Contract.ValueData       AS ContractName
                        , Object_PaidKind.ValueData       AS PaidKindName
                 
                        , Object_Insert.ValueData         AS InsertName
                        , ObjectDate_Insert.ValueData     AS InsertDate
                 
                        , Object_Buh.ValueData            AS BuhName
                        , tmpReport.BuhDate
                 
                        , COALESCE (ObjectBoolean_Buh.ValueData, FALSE) ::Boolean  AS isBuh
                        
                        , COALESCE (ObjectLink_ReportCollation_PaidKind.ChildObjectId , 0) AS PaidKindId
                        , COALESCE (ObjectLink_ReportCollation_Contract.ChildObjectId,  0) AS ContractId
                        , COALESCE (ObjectLink_ReportCollation_Partner.ChildObjectId,   0) AS PartnerId
                        , COALESCE (ObjectLink_ReportCollation_Juridical.ChildObjectId, 0) AS JuridicalId

                    FROM tmpReport
                       LEFT JOIN Object AS Object_ReportCollation ON Object_ReportCollation.Id = tmpReport.Id
                       LEFT JOIN ObjectDate AS ObjectDate_Start
                                            ON ObjectDate_Start.ObjectId = tmpReport.Id
                                           AND ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
                       LEFT JOIN ObjectDate AS ObjectDate_End
                                             ON ObjectDate_End.ObjectId = tmpReport.Id
                                            AND ObjectDate_End.DescId = zc_ObjectDate_ReportCollation_End()
                  
                       LEFT JOIN ObjectDate AS ObjectDate_Insert
                                            ON ObjectDate_Insert.ObjectId = tmpReport.Id
                                           AND ObjectDate_Insert.DescId = zc_ObjectDate_ReportCollation_Insert()
                 
                       LEFT JOIN ObjectBoolean AS ObjectBoolean_Buh
                                               ON ObjectBoolean_Buh.ObjectId = tmpReport.Id
                                              AND ObjectBoolean_Buh.DescId = zc_ObjectBoolean_ReportCollation_Buh()
                 
                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                            ON ObjectLink_ReportCollation_PaidKind.ObjectId = tmpReport.Id
                                           AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
                       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ReportCollation_PaidKind.ChildObjectId
                       
                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                            ON ObjectLink_ReportCollation_Juridical.ObjectId = tmpReport.Id
                                           AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
                       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_ReportCollation_Juridical.ChildObjectId
                       
                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                            ON ObjectLink_ReportCollation_Partner.ObjectId = tmpReport.Id
                                           AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
                       LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ReportCollation_Partner.ChildObjectId
                 
                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                            ON ObjectLink_ReportCollation_Contract.ObjectId = tmpReport.Id
                                           AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
                       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ReportCollation_Contract.ChildObjectId
                 
                       LEFT JOIN ObjectLink AS ObjectLink_Insert
                                            ON ObjectLink_Insert.ObjectId = tmpReport.Id
                                           AND ObjectLink_Insert.DescId = zc_ObjectLink_ReportCollation_Insert()
                       LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   
                 
                       LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = tmpReport.BuhId
                 
                  -- WHERE Object_ReportCollation.DescId = zc_Object_ReportCollation()
                   )
      -- Результат
      SELECT tmpData.Id
           , tmpData.ObjectCode
           , tmpData.idBarCode
           , tmpData.idBarCode AS BarCode_Sale
           , tmpData.StartDate
           , tmpData.EndDate
           , tmpData.JuridicalName
           , tmpData.PartnerName
           , tmpData.ContractName
           , tmpData.PaidKindName

           , tmpData.InsertName
           , tmpData.InsertDate

           , tmpData.BuhName
           , tmpData.BuhDate

           , tmpData.isBuh

           , CASE WHEN tmpData.ObjectCode > 1 AND tmpData_old.EndDate <> tmpData.StartDate - INTERVAL '1 DAY' THEN TRUE ELSE FALSE END :: Boolean AS isDiff
           
      FROM tmpData
           LEFT JOIN tmpData AS	 tmpData_old ON tmpData_old.PaidKindId  = tmpData.PaidKindId
                                            AND tmpData_old.ContractId  = tmpData.ContractId
                                            AND tmpData_old.PartnerId   = tmpData.PartnerId
                                            AND tmpData_old.JuridicalId = tmpData.JuridicalId
                                            AND tmpData_old.ObjectCode  = tmpData.ObjectCode - 1
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.01.17         *
*/

-- тест
-- SELECT * FROM gpSelect_ReportCollation_byUser (inStartDate := '24.01.2017', inEndDate:= '24.01.2017', inSession := '5');
