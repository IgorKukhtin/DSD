-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportCollation (TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_ReportCollation(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --dfsdfsdfsdfsdf
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ObjectCode Integer, idBarCode TVarChar
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
             , StartRemainsRep TFloat
             , EndRemainsRep TFloat
             , StartRemains TFloat
             , EndRemains TFloat
             , StartRemainsCalc TFloat
             , EndRemainsCalc TFloat
             , isBuh Boolean
             , isDiff Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY
   WITH tmpData AS (SELECT
                          Object_ReportCollation.Id
                        , Object_ReportCollation.ObjectCode
                        , zfFormat_BarCode (zc_BarCodePref_Object(), Object_ReportCollation.Id) ::TVarChar AS idBarCode
                        , ObjectDate_Start.ValueData      AS StartDate
                        , ObjectDate_End.ValueData        AS EndDate
                        , Object_Juridical.ValueData      AS JuridicalName
                        , Object_Partner.ValueData        AS PartnerName
                        , Object_Contract.ValueData       AS ContractName
                        , Object_PaidKind.ValueData       AS PaidKindName

                        , Object_Insert.ValueData         AS InsertName
                        , ObjectDate_Insert.ValueData     AS InsertDate

                        , Object_Buh.ValueData            AS BuhName
                        , ObjectDate_Buh.ValueData        AS BuhDate

                        , COALESCE (ObjectBoolean_Buh.ValueData, FALSE) ::Boolean  AS isBuh
                        , Object_ReportCollation.isErased

                        , COALESCE (ObjectLink_ReportCollation_PaidKind.ChildObjectId , 0) AS PaidKindId
                        , COALESCE (ObjectLink_ReportCollation_Contract.ChildObjectId,  0) AS ContractId
                        , COALESCE (ObjectLink_ReportCollation_Partner.ChildObjectId,   0) AS PartnerId
                        , COALESCE (ObjectLink_ReportCollation_Juridical.ChildObjectId, 0) AS JuridicalId
                        
                        , COALESCE (ObjectFloat_StartRemainsRep.ValueData, 0)     AS StartRemainsRep
                        , COALESCE (ObjectFloat_EndRemainsRep.ValueData, 0)       AS EndRemainsRep
                        , COALESCE (ObjectFloat_StartRemains.ValueData, 0)        AS StartRemains
                        , COALESCE (ObjectFloat_EndRemains.ValueData, 0)          AS EndRemains
                        , COALESCE (ObjectFloat_StartRemainsCalc.ValueData, 0)    AS StartRemainsCalc
                        , COALESCE (ObjectFloat_EndRemainsCalc.ValueData, 0)      AS EndRemainsCalc

                    FROM Object AS Object_ReportCollation
                       LEFT JOIN ObjectDate AS ObjectDate_Start
                                            ON ObjectDate_Start.ObjectId = Object_ReportCollation.Id
                                           AND ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
                       LEFT JOIN ObjectDate AS ObjectDate_End
                                             ON ObjectDate_End.ObjectId = Object_ReportCollation.Id
                                            AND ObjectDate_End.DescId = zc_ObjectDate_ReportCollation_End()

                       LEFT JOIN ObjectDate AS ObjectDate_Insert
                                            ON ObjectDate_Insert.ObjectId = Object_ReportCollation.Id
                                           AND ObjectDate_Insert.DescId = zc_ObjectDate_ReportCollation_Insert()

                       LEFT JOIN ObjectDate AS ObjectDate_Buh
                                            ON ObjectDate_Buh.ObjectId = Object_ReportCollation.Id
                                           AND ObjectDate_Buh.DescId = zc_ObjectDate_ReportCollation_Buh()

                       LEFT JOIN ObjectBoolean AS ObjectBoolean_Buh
                                               ON ObjectBoolean_Buh.ObjectId = Object_ReportCollation.Id
                                              AND ObjectBoolean_Buh.DescId = zc_ObjectBoolean_ReportCollation_Buh()

                       LEFT JOIN ObjectFloat AS ObjectFloat_StartRemainsRep
                                             ON ObjectFloat_StartRemainsRep.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_StartRemainsRep.DescId = zc_ObjectFloat_ReportCollation_StartRemainsRep()
                       LEFT JOIN ObjectFloat AS ObjectFloat_EndRemainsRep
                                             ON ObjectFloat_EndRemainsRep.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_EndRemainsRep.DescId = zc_ObjectFloat_ReportCollation_EndRemainsRep()
                       LEFT JOIN ObjectFloat AS ObjectFloat_StartRemains
                                             ON ObjectFloat_StartRemains.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_StartRemains.DescId = zc_ObjectFloat_ReportCollation_StartRemains()
                       LEFT JOIN ObjectFloat AS ObjectFloat_EndRemains
                                             ON ObjectFloat_EndRemains.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_EndRemains.DescId = zc_ObjectFloat_ReportCollation_EndRemains()
                       LEFT JOIN ObjectFloat AS ObjectFloat_StartRemainsCalc
                                             ON ObjectFloat_StartRemainsCalc.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_StartRemainsCalc.DescId = zc_ObjectFloat_ReportCollation_StartRemainsCalc()
                       LEFT JOIN ObjectFloat AS ObjectFloat_EndRemainsCalc
                                             ON ObjectFloat_EndRemainsCalc.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_EndRemainsCalc.DescId = zc_ObjectFloat_ReportCollation_EndRemainsCalc()
                                  
                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                            ON ObjectLink_ReportCollation_PaidKind.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
                       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ReportCollation_PaidKind.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                            ON ObjectLink_ReportCollation_Juridical.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
                       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_ReportCollation_Juridical.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                            ON ObjectLink_ReportCollation_Partner.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
                       LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ReportCollation_Partner.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                            ON ObjectLink_ReportCollation_Contract.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
                       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ReportCollation_Contract.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Insert
                                            ON ObjectLink_Insert.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_Insert.DescId = zc_ObjectLink_ReportCollation_Insert()
                       LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Buh
                                            ON ObjectLink_Buh.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_Buh.DescId = zc_ObjectLink_ReportCollation_Buh()
                       LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = ObjectLink_Buh.ChildObjectId

                   WHERE Object_ReportCollation.DescId = zc_Object_ReportCollation()
                     AND ObjectDate_Start.ValueData >= inStartDate
                     AND ObjectDate_End.ValueData <= inEndDate
                   )
                   
      SELECT tmpData.Id
           , tmpData.ObjectCode
           , tmpData.idBarCode
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

           , tmpData.StartRemainsRep  :: TFloat  AS StartRemainsRep
           , tmpData.EndRemainsRep    :: TFloat  AS EndRemainsRep
           , tmpData.StartRemains     :: TFloat  AS StartRemains
           , tmpData.EndRemains       :: TFloat  AS EndRemains
           , tmpData.StartRemainsCalc :: TFloat  AS StartRemainsCalc
           , tmpData.EndRemainsCalc   :: TFloat  AS EndRemainsCalc

           , tmpData.isBuh

           , CASE WHEN tmpData.ObjectCode > 1 AND tmpData_old.EndDate <> tmpData.StartDate - INTERVAL '1 DAY' THEN TRUE ELSE FALSE END :: Boolean AS isDiff
           
           , tmpData.isErased

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
 14.10.18         * 
 20.01.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReportCollation (inStartDate:= NULL, inEndDate:= NULL, inSession := zfCalc_UserAdmin())
