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
       , ObjectHistoryString_INN.ValueData              AS INN
       , ObjectHistoryString_NumberVAT.ValueData        AS NumberVAT
       , ObjectHistoryString_AccounterName.ValueData    AS AccounterName
       , ObjectHistoryString_BankAccount.ValueData      AS BankAccount
--       , ObjectHistoryString_Phone.ValueData            AS Phone

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
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_BankAccount
                                ON ObjectHistoryString_BankAccount.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_BankAccount.DescId = zc_ObjectHistoryString_JuridicalDetails_BankAccount()
/*
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_Phone
                                ON ObjectHistoryString_Phone.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_Phone.DescId = zc_ObjectHistoryString_JuridicalDetails_Phone()
*/
  WHERE ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
 ;


ALTER TABLE ObjectHistory_JuridicalDetails_ViewByDate  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 05.02.14                                                       *
*/

-- ����
-- SELECT * FROM ObjectHistory_JuridicalDetails_ViewByDate