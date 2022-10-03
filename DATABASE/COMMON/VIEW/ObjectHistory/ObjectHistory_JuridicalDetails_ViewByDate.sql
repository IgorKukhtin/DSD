-- View: ObjectHistory_JuridicalDetails_ViewByDate

DROP VIEW IF EXISTS ObjectHistory_JuridicalDetails_ViewByDate;

CREATE OR REPLACE VIEW ObjectHistory_JuridicalDetails_ViewByDate AS
  SELECT ObjectHistory_JuridicalDetails.Id              AS ObjectHistoryId
       , ObjectHistory_JuridicalDetails.StartDate       AS StartDate
       , ObjectHistory_JuridicalDetails.EndDate         AS EndDate
       , ObjectHistory_JuridicalDetails.ObjectId        AS JuridicalId
       , ObjectHistoryString_FullName.ValueData         AS FullName
       , ObjectHistoryString_JuridicalAddress.ValueData AS JuridicalAddress
       , ObjectHistoryString_OKPO.ValueData             AS OKPO
--       , ObjectHistoryString_INN.ValueData              AS INN
       , CAST (REPEAT (' ', 12 - LENGTH (ObjectHistoryString_INN.ValueData)) || ObjectHistoryString_INN.ValueData AS TVarChar) AS INN
       , ObjectHistoryString_NumberVAT.ValueData        AS NumberVAT
       , ObjectHistoryString_AccounterName.ValueData    AS AccounterName
       , ObjectHistoryString_MainName.ValueData         AS MainName
       , ObjectHistoryString_BankAccount.ValueData      AS BankAccount
       , Object_Bank.Id                                 AS BankId
       , Object_Bank.valuedata                          AS BankName
       , ObjectString_MFO.ValueData                     AS MFO
       , COALESCE (ObjectHistoryString_Phone.ValueData, CAST ('' AS TVarChar)) AS Phone
       , COALESCE (ObjectHistoryString_InvNumberBranch.ValueData, CAST ('' AS TVarChar)) AS InvNumberBranch
       , ObjectHistoryString_Name.ValueData             AS Name

  FROM ObjectHistory AS ObjectHistory_JuridicalDetails

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_FullName
                                ON ObjectHistoryString_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalAddress
                                ON ObjectHistoryString_JuridicalAddress.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_JuridicalAddress.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_OKPO
                                ON ObjectHistoryString_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_INN
                                ON ObjectHistoryString_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_NumberVAT
                                ON ObjectHistoryString_NumberVAT.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_NumberVAT.DescId = zc_ObjectHistoryString_JuridicalDetails_NumberVAT()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_AccounterName
                                ON ObjectHistoryString_AccounterName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_AccounterName.DescId = zc_ObjectHistoryString_JuridicalDetails_AccounterName()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_MainName
                                ON ObjectHistoryString_MainName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_MainName.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_BankAccount
                                ON ObjectHistoryString_BankAccount.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_BankAccount.DescId = zc_ObjectHistoryString_JuridicalDetails_BankAccount()

  LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Bank
                                ON ObjectHistoryLink_Bank.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryLink_Bank.DescId = zc_ObjectHistoryLink_JuridicalDetails_Bank()
  LEFT JOIN Object AS Object_Bank ON Object_Bank.id = ObjectHistoryLink_Bank.ObjectId
  LEFT JOIN ObjectString AS ObjectString_MFO ON ObjectString_MFO.ObjectId = Object_Bank.Id
                                            AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_Phone
                                ON ObjectHistoryString_Phone.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_Phone.DescId = zc_ObjectHistoryString_JuridicalDetails_Phone()

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_InvNumberBranch
                                ON ObjectHistoryString_InvNumberBranch.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_InvNumberBranch.DescId = zc_ObjectHistoryString_JuridicalDetails_InvNumberBranch()

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_Name
                                ON ObjectHistoryString_Name.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_Name.DescId = zc_ObjectHistoryString_JuridicalDetails_Name() 

  WHERE ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
 ;


ALTER TABLE ObjectHistory_JuridicalDetails_ViewByDate  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.04.16         * InvNumberBranch 
 26.11.15         * add MainName
 14.04.14                                                       *  -- выравнивание пробелами INN для печати
 12.02.14                                                       *  + phone
 07.02.14                                                       *  + bank
 05.02.14                                                       *
*/

-- тест
-- SELECT * FROM ObjectHistory_JuridicalDetails_ViewByDate
