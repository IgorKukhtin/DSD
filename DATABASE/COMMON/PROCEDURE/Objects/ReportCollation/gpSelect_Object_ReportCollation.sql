-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportCollation (TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_ReportCollation(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, idBarCode TVarChar
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
   SELECT
         Object_ReportCollation.Id
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

       , COALESCE (ObjectBoolean_Buh.ValueData, False) ::Boolean  AS isBuh
       , Object_ReportCollation.isErased
       
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
   ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.01.17         *
*/

-- тест
--SELECT * FROM gpSelect_Object_ReportCollation (inStartDate:= NULL, inEndDate:= NULL, inSession := zfCalc_UserAdmin())
