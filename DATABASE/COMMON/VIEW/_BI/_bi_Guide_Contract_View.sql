-- View: _bi_Guide_Contract_View

 DROP VIEW IF EXISTS _bi_Guide_Contract_View;

-- ���������� ��������
CREATE OR REPLACE VIEW _bi_Guide_Contract_View
AS
  WITH -- ��� ������� ��������
       tmpContractCondition_Value_all AS (SELECT -- �������
                                                 View_ContractCondition_Value.ContractId
                                                 -- ��� ������� ��������
                                               , View_ContractCondition_Value.ContractConditionKind

                                                 -- (-)% ������ (+)% �������
                                               , View_ContractCondition_Value.ChangePercent
                                                 -- % ������� ��������� (������ ����������)
                                               , View_ContractCondition_Value.ChangePercentPartner
                                                 -- ������ � ���� ���
                                               , View_ContractCondition_Value.ChangePrice

                                                 -- �������� � ����������� ����
                                               , View_ContractCondition_Value.DayCalendar
                                                 -- �������� � ���������� ����
                                               , View_ContractCondition_Value.DayBank

                                                 -- ������ ��� ������� � ....
                                               , View_ContractCondition_Value.StartDate
                                                 -- ������ ��� ������� �� ....
                                               , View_ContractCondition_Value.EndDate
                                                 -- � �/�
                                               , ROW_NUMBER() OVER (PARTITION BY View_ContractCondition_Value.ContractId, View_ContractCondition_Value.ContractConditionKind
                                                                    ORDER BY View_ContractCondition_Value.StartDate DESC
                                                                   ) AS Ord

                                          FROM Object_ContractCondition_ValueView_all AS View_ContractCondition_Value
                                          -- WHERE CURRENT_DATE BETWEEN View_ContractCondition_Value.StartDate AND View_ContractCondition_Value.EndDate
                                          --   AND COALESCE (View_ContractCondition_Value.EndDate, zc_DateEnd()) >= CURRENT_DATE
                                          --   AND COALESCE (View_ContractCondition_Value.EndDate, zc_DateEnd()) = zc_DateEnd()
                                         )
       -- ��������� ������� ��������
     , tmpContractCondition_Value AS (SELECT tmpContractCondition_Value_all.ContractId
                                             -- (-)% ������ (+)% �������
                                           , MAX (tmpContractCondition_Value_all.ChangePercent)        :: TFloat AS ChangePercent
                                             -- % ������� ��������� (������ ����������)
                                           , MAX (tmpContractCondition_Value_all.ChangePercentPartner) :: TFloat AS ChangePercentPartner
                                             -- ������ � ���� ���
                                           , MAX (tmpContractCondition_Value_all.ChangePrice)          :: TFloat AS ChangePrice

                                             -- �������� � ����������� ����
                                           , MAX (tmpContractCondition_Value_all.DayCalendar) :: TFloat AS DayCalendar
                                             -- �������� � ���������� ����
                                           , MAX (tmpContractCondition_Value_all.DayBank)     :: TFloat AS DayBank
                                             -- �������� - ������������
                                           , CASE WHEN 0 <> MAX (tmpContractCondition_Value_all.DayCalendar)
                                                      THEN (MAX (tmpContractCondition_Value_all.DayCalendar) :: Integer) :: TVarChar || ' �.��.'
                                                  WHEN 0 <> MAX (tmpContractCondition_Value_all.DayBank)
                                                      THEN (MAX (tmpContractCondition_Value_all.DayBank)     :: Integer) :: TVarChar || ' �.��.'
                                                  ELSE '0 ��.'
                                             END :: TVarChar  AS DelayDay

                                             -- ������ ��� ������� � ....
                                           , MAX (tmpContractCondition_Value_all.StartDate) :: TDateTime AS StartDate
                                             -- ������ ��� ������� �� ....
                                           , MAX (tmpContractCondition_Value_all.EndDate)   :: TDateTime AS EndDate

                                      FROM tmpContractCondition_Value_all
                                      -- !!!��������� ������� ��������!!!
                                      WHERE tmpContractCondition_Value_all.Ord = 1
                                      -- ������� � ���� �������
                                      GROUP BY tmpContractCondition_Value_all.ContractId
                                     )
  -- ���������
  SELECT Object_Contract.Id         AS ContractId
       , Object_Contract.ObjectCode AS ContractCode
       , Object_Contract.ValueData  AS InvNumber
         -- ������� "������ ��/���"
       , Object_Contract.isErased

         -- ������������ � ������� - ������� "������������" �����������, ��� ContractCode + InvNumber
       , COALESCE (Object_Contract_key.Id,         Object_Contract.Id)         :: Integer  AS ContractId_key
       , COALESCE (Object_Contract_key.ObjectCode, Object_Contract.ObjectCode) :: Integer  AS ContractCode_key
       , COALESCE (Object_Contract_key.ValueData,  Object_Contract.ValueData)  :: TVarChar AS InvNumber_key
       , COALESCE (Object_Contract_key.isErased,   Object_Contract.isErased)   :: Boolean  AS isErased_key

         -- ����������� ����
       , Object_Juridical.Id               AS JuridicalId
       , Object_Juridical.ObjectCode       AS JuridicalCode
       , Object_Juridical.ValueData        AS JuridicalName
         -- ����� ������
       , Object_PaidKind.ObjectCode        AS PaidKindCode
       , Object_PaidKind.ValueData         AS PaidKindName

         -- ������� ����������� ����
       , Object_Juridical_basis.Id         AS JuridicalId_basis
       , Object_Juridical_basis.ObjectCode AS JuridicalCode_basis
       , Object_Juridical_basis.ValueData  AS JuridicalName_basis

         -- ����������� ���� - ������ ���. - �������
       , Object_Juridical_Doc.Id           AS JuridicalId_doc
       , Object_Juridical_Doc.ObjectCode   AS JuridicalCode_doc
       , Object_Juridical_Doc.ValueData    AS JuridicalName_doc

       --����������� ����(������ ���. - ��������� �����������)
       , Object_JuridicalInvoice.Id              AS JuridicalInvoiceId
       , Object_JuridicalInvoice.ObjectCode      AS JuridicalInvoiceCode
       , Object_JuridicalInvoice.ValueData       AS JuridicalInvoiceName
       --�������������� ������� �������
       , Object_GoodsProperty.Id                 AS GoodsPropertyId
       , Object_GoodsProperty.ValueData          AS GoodsPropertyName
       -- 	���������� (������������� ����)     
       , Object_Personal.Id                      AS PersonalId
       , Object_Personal.ObjectCode              AS PersonalCode
       , Object_Personal.ValueData               AS PersonalName
       --���������� (��������)
       , Object_PersonalTrade.Id                 AS PersonalTradeId
       , Object_PersonalTrade.ObjectCode         AS PersonalTradeCode
       , Object_PersonalTrade.ValueData          AS PersonalTradeName
       --���������� (������)
       , Object_PersonalCollation.Id             AS PersonalCollationId
       , Object_PersonalCollation.ObjectCode     AS PersonalCollationCode
       , Object_PersonalCollation.ValueData      AS PersonalCollationName
       --���������� (���������)
       , Object_PersonalSigning.Id               AS PersonalSigningId
       , Object_PersonalSigning.ObjectCode       AS PersonalSigningCode
       , Object_PersonalSigning.ValueData        AS PersonalSigningName
       --��������� ���� (��.������)
       , Object_BankAccount.Id                   AS BankAccountId
       , Object_BankAccount.ValueData            AS BankAccountName
       --������(��������)
       , Object_AreaContract.Id                  AS AreaContractId
       , Object_AreaContract.ValueData           AS AreaContractName
       --������� ��������
       , Object_ContractArticle.Id               AS ContractArticleId
       , Object_ContractArticle.ValueData        AS ContractArticleName
       --����(���.������)
       , Object_Bank.Id                          AS BankId
       , Object_Bank.ValueData                   AS BankName
       --������ (������� ���)
       , Object_Branch.Id                        AS BranchId
       , Object_Branch.ValueData                 AS BranchName
                    
         -- ���� � ������� ��������� �������
       , CASE -- ��� ����� ���������
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: TDateTime
              ELSE ObjectDate_Start.ValueData
         END :: TDateTime AS StartDate

         -- ���� �� ������� ��������� ������� - ������
       , CASE -- ��� ����� ���������
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: TDateTime
              -- ���� ��� ����������� ��������� = ����������
              WHEN ObjectLink_Contract_ContractTermKind.ChildObjectId = zc_Enum_ContractTermKind_Long()
                   THEN ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL
              -- ���� ��� ����������� ��������� = �� ������ � �������
              WHEN ObjectLink_Contract_ContractTermKind.ChildObjectId = zc_Enum_ContractTermKind_Month() AND ObjectFloat_Term.ValueData > 0
                   THEN ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL
              -- ����� ��� ���������
              ELSE ObjectDate_End.ValueData
         END :: TDateTime AS EndDate

         -- ���� �� ������� ��������� ������� - ������������
       , CASE -- ��� ����� ���������
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: TDateTime
              ELSE ObjectDate_End.ValueData
         END :: TDateTime AS EndDate_real

        --���� ���������� ��������
       , ObjectDate_Signing.ValueData AS SigningDate
        -- ��� ����������� ���������
       , Object_ContractTermKind.ValueData                  AS ContractTermKindName
        -- ������ ����������� � �������
       , COALESCE (ObjectFloat_Term.ValueData, 0) :: TFloat AS Term

        -- �� ������ ����������
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName

         -- ��������� ��������
       , Object_ContractStateKind.ObjectCode AS ContractStateKindCode
       , Object_ContractStateKind.ValueData  AS ContractStateKindName

         -- ������ ������� ��������
       , Object_ContractTagGroup.ObjectCode  AS ContractTagGroupCode
       , Object_ContractTagGroup.ValueData   AS ContractTagGroupName
         -- ������� ��������
       , Object_ContractTag.ObjectCode       AS ContractTagCode
       , Object_ContractTag.ValueData        AS ContractTagName

         -- ��� �������� - ���
       , CASE -- ��� ����� ���������
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: Integer
              ELSE Object_ContractKind.ObjectCode
         END :: Integer AS ContractKindCode
         -- ��� �������� - ��������
       , CASE -- ��� ����� ���������
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: TVarChar
              ELSE Object_ContractKind.ValueData
         END :: TVarChar AS ContractKindName

         -- ������� �������� - (-)% ������ (+)% �������
       , View_ContractCondition_Value.ChangePercent
         -- ������� �������� - % ������� ��������� (������ ����������)
       , View_ContractCondition_Value.ChangePercentPartner
         -- ������� �������� - ������ � ���� ���
       , View_ContractCondition_Value.ChangePrice

         -- ������� �������� - ������ � ���� ���
       , View_ContractCondition_Value.DayCalendar
         -- ������� �������� - �������� � ���������� ����
       , View_ContractCondition_Value.DayBank
         -- ������� �������� - �������� � ����������� ����
       , View_ContractCondition_Value.DelayDay

         -- ������ ��� ������� � ....
       , COALESCE (View_ContractCondition_Value.StartDate, zc_DateStart()) AS StartDate_condition
         -- ������ ��� ������� �� ....
       , COALESCE (View_ContractCondition_Value.EndDate, zc_DateEnd())     AS EndDate_condition
       
       --�� ��������� (��� ��. ��������) 
       , COALESCE (ObjectBoolean_Default.ValueData, False)   :: Boolean  AS isDefault
       --�� ��������� (��� ���. ��������)
       , COALESCE (ObjectBoolean_DefaultOut.ValueData, False):: Boolean  AS isDefaultOut
       --�������
       , COALESCE (ObjectBoolean_Standart.ValueData, False)  :: Boolean  AS isStandart

       --��������� ������� 
       , COALESCE (ObjectBoolean_Personal.ValueData, False) :: Boolean AS isPersonal
       --��� ����������� 
       , COALESCE (ObjectBoolean_Unique.ValueData, False)   :: Boolean AS isUnique
       --������ 0% (�������)
       , COALESCE (ObjectBoolean_Vat.ValueData, False)      :: Boolean AS isVat
       --������ ��� ��� (������ 0%)
       , COALESCE (ObjectBoolean_NotVat.ValueData, False)             :: Boolean AS isNotVat
       --����
       , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)         :: Boolean AS isIrna   
       --��� �����
       , COALESCE (ObjectBoolean_RealEx.ValueData, False)             :: Boolean AS isRealEx
       --��� �������� ����
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning
       --����������� ������ ���������
       , COALESCE (ObjectBoolean_MarketNot.ValueData, FALSE)          :: Boolean AS isMarketNot
       --�������� ������ ��� ���
       , COALESCE (ObjectBoolean_isWMS.ValueData, FALSE)              :: Boolean AS isWMS
       --���-�� ���� ��� ������� ���������
       , ObjectFloat_DayTaxSummary.ValueData AS DayTaxSummary
       --���������� ��������� �� ��������
       , ObjectFloat_DocumentCount.ValueData AS DocumentCount
       --���� ���������� ���������
       , ObjectDate_Document.ValueData AS DateDocument       
       --� �������������
       , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive
       --����������
       , ObjectString_Comment.ValueData            AS Comment
       --��������� ���� (���.������)
       , ObjectString_BankAccount.ValueData        AS BankAccountExternal
       --��������� ���� (����������)
       , ObjectString_BankAccountPartner.ValueData AS BankAccountPartner
       --��� GLN
       , ObjectString_GLNCode.ValueData            AS GLNCode
       --��� ����������
       , ObjectString_PartnerCode.ValueData        AS PartnerCode
       --���� ������ �����   
       , COALESCE (ObjectDate_StartPromo.ValueData,CAST (CURRENT_DATE as TDateTime)) AS StartPromo
       --���� ��������� �����
       , COALESCE (ObjectDate_EndPromo.ValueData,CAST (CURRENT_DATE as TDateTime))   AS EndPromo     
              
       -- ������������ (��������)
       , Object_Insert.ValueData   AS InsertName
       -- ������������ (�������������)
       , Object_Update.ValueData   AS UpdateName
       --���� ��������
       , ObjectDate_Protocol_Insert.ValueData AS InsertDate
       --���� �������������
       , ObjectDate_Protocol_Update.ValueData AS UpdateDate
       
  FROM Object AS Object_Contract
       -- ��������� ������� ��������
       LEFT JOIN tmpContractCondition_Value AS View_ContractCondition_Value ON View_ContractCondition_Value.ContractId = Object_Contract.Id

       -- ����� ���� - ������������ �������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKey
                            ON ObjectLink_Contract_ContractKey.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractKey.DescId   = zc_ObjectLink_Contract_ContractKey()
       -- ����� ������� "������������" �����������
       LEFT JOIN ObjectLink AS ObjectLink_ContractKey_Contract
                            ON ObjectLink_ContractKey_Contract.ObjectId = ObjectLink_Contract_ContractKey.ChildObjectId
                           AND ObjectLink_ContractKey_Contract.DescId   = zc_ObjectLink_ContractKey_Contract()
       -- ������� "������������" �����������
       LEFT JOIN Object AS Object_Contract_key ON Object_Contract_key.Id = ObjectLink_ContractKey_Contract.ChildObjectId

       -- ����������� ����
       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                            ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId

       -- ����� ������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_Contract_PaidKind.ChildObjectId

       -- ������� ����������� ����
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                            ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_JuridicalBasis.DescId   = zc_ObjectLink_Contract_JuridicalBasis()
       LEFT JOIN Object AS Object_Juridical_basis ON Object_Juridical_basis.Id = ObjectLink_Contract_JuridicalBasis.ChildObjectId

       -- ����������� ���� - ������ ���.
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDoc
                            ON ObjectLink_Contract_JuridicalDoc.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_JuridicalDoc.DescId   = zc_ObjectLink_Contract_JuridicalDocument()
       -- ���� � ������� ��������� ����������� ���� - ������ ���. - �������
       LEFT JOIN ObjectDate AS ObjectDate_JuridicalDoc_Next
                            ON ObjectDate_JuridicalDoc_Next.ObjectId = Object_Contract.Id
                           AND ObjectDate_JuridicalDoc_Next.DescId   = zc_ObjectDate_Contract_JuridicalDoc_Next()
       -- ����������� ���� - ������ ���. - �������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDoc_Next
                            ON ObjectLink_Contract_JuridicalDoc_Next.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_JuridicalDoc_Next.DescId   = zc_ObjectLink_Contract_JuridicalDoc_Next()
                           -- !!!���� ���� ��������!!!
                           AND ObjectDate_JuridicalDoc_Next.ValueData >= CURRENT_DATE
       LEFT JOIN Object AS Object_Juridical_Doc ON Object_Juridical_Doc.Id = COALESCE (ObjectLink_Contract_JuridicalDoc_Next.ChildObjectId, ObjectLink_Contract_JuridicalDoc.ChildObjectId)
       --����������� ����(������ ���. - ��������� �����������)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                            ON ObjectLink_Contract_JuridicalInvoice.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_JuridicalInvoice.DescId = zc_ObjectLink_Contract_JuridicalInvoice()
       LEFT JOIN Object AS Object_JuridicalInvoice ON Object_JuridicalInvoice.Id = ObjectLink_Contract_JuridicalInvoice.ChildObjectId
       --�������������� ������� �������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                            ON ObjectLink_Contract_GoodsProperty.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
       LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Contract_GoodsProperty.ChildObjectId 
       --���������� (������������� ����)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                            ON ObjectLink_Contract_Personal.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
       LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId               
       --���������� (��������)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                            ON ObjectLink_Contract_PersonalTrade.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
       LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Contract_PersonalTrade.ChildObjectId
       --���������� (������)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                            ON ObjectLink_Contract_PersonalCollation.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
       LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = ObjectLink_Contract_PersonalCollation.ChildObjectId        
       --���������� (���������)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                            ON ObjectLink_Contract_PersonalSigning.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
       LEFT JOIN Object AS Object_PersonalSigning ON Object_PersonalSigning.Id = ObjectLink_Contract_PersonalSigning.ChildObjectId   
       --��������� ���� (��.������)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                            ON ObjectLink_Contract_BankAccount.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
       LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId
       --������(��������)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_AreaContract
                            ON ObjectLink_Contract_AreaContract.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_AreaContract.DescId = zc_ObjectLink_Contract_AreaContract()
       LEFT JOIN Object AS Object_AreaContract ON Object_AreaContract.Id = ObjectLink_Contract_AreaContract.ChildObjectId                     
       --������� ��������    
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                            ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
       LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
       --����(���.������)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_Bank
                            ON ObjectLink_Contract_Bank.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_Bank.DescId = zc_ObjectLink_Contract_Bank()
       LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Contract_Bank.ChildObjectId
       --������ (������� ���)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_Branch
                            ON ObjectLink_Contract_Branch.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_Branch.DescId = zc_ObjectLink_Contract_Branch()
       LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Contract_Branch.ChildObjectId       
       --���� ��������
       LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                            ON ObjectDate_Protocol_Insert.ObjectId = Object_Contract.Id
                           AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       --���� �������������
       LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                            ON ObjectDate_Protocol_Update.ObjectId = Object_Contract.Id
                           AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
       --������������ (��������)
       LEFT JOIN ObjectLink AS ObjectLink_Insert
                            ON ObjectLink_Insert.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
       LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   
       -- 	������������ (�������������)
       LEFT JOIN ObjectLink AS ObjectLink_Update
                            ON ObjectLink_Update.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
       LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId   

       -- ���� � ������� ��������� �������
       LEFT JOIN ObjectDate AS ObjectDate_Start
                            ON ObjectDate_Start.ObjectId = Object_Contract.Id
                           AND ObjectDate_Start.DescId   = zc_ObjectDate_Contract_Start()
       -- ���� �� ������� ��������� ������� - ������������
       LEFT JOIN ObjectDate AS ObjectDate_End
                            ON ObjectDate_End.ObjectId = Object_Contract.Id
                           AND ObjectDate_End.DescId   = zc_ObjectDate_Contract_End()

       -- �� ������ ����������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

       -- ��������� ��������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                            ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractStateKind.DescId   = zc_ObjectLink_Contract_ContractStateKind()
       LEFT JOIN Object AS Object_ContractStateKind ON Object_ContractStateKind.Id = ObjectLink_Contract_ContractStateKind.ChildObjectId

       -- ������� ��������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                            ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractTag.DescId   = zc_ObjectLink_Contract_ContractTag()
       LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
       -- + ��� ���� ������ ������� ��������
       LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagGroup
                            ON ObjectLink_ContractTag_ContractTagGroup.ObjectId = Object_ContractTag.Id
                           AND ObjectLink_ContractTag_ContractTagGroup.DescId   = zc_ObjectLink_ContractTag_ContractTagGroup()
       LEFT JOIN Object AS Object_ContractTagGroup ON Object_ContractTagGroup.Id = ObjectLink_ContractTag_ContractTagGroup.ChildObjectId

       -- ��� ��������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                            ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractKind.DescId   = zc_ObjectLink_Contract_ContractKind()
       LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

       -- ������ �����������
       LEFT JOIN ObjectFloat AS ObjectFloat_Term
                             ON ObjectFloat_Term.ObjectId = Object_Contract.Id
                            AND ObjectFloat_Term.DescId   = zc_ObjectFloat_Contract_Term()
       -- ��� ����������� ���������
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTermKind
                            ON ObjectLink_Contract_ContractTermKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractTermKind.DescId   = zc_ObjectLink_Contract_ContractTermKind()
       LEFT JOIN Object AS Object_ContractTermKind ON Object_ContractTermKind.Id = ObjectLink_Contract_ContractTermKind.ChildObjectId
       --�� ��������� (��� ��. ��������)
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                               ON ObjectBoolean_Default.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
       --�� ��������� (��� ���. ��������)
       LEFT JOIN ObjectBoolean AS ObjectBoolean_DefaultOut
                               ON ObjectBoolean_DefaultOut.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_DefaultOut.DescId = zc_ObjectBoolean_Contract_DefaultOut()
       --�������
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Standart
                               ON ObjectBoolean_Standart.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Standart.DescId = zc_ObjectBoolean_Contract_Standart()
       --��������� �������
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal
                               ON ObjectBoolean_Personal.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Personal.DescId = zc_ObjectBoolean_Contract_Personal()
       --��� �����������
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Unique
                               ON ObjectBoolean_Unique.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Unique.DescId = zc_ObjectBoolean_Contract_Unique()
       --��� �����
       LEFT JOIN ObjectBoolean AS ObjectBoolean_RealEx
                               ON ObjectBoolean_RealEx.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()
       --������ 0% (�������)
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Vat
                               ON ObjectBoolean_Vat.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Vat.DescId = zc_ObjectBoolean_Contract_Vat()
       --������ ��� ��� (������ 0%)
       LEFT JOIN ObjectBoolean AS ObjectBoolean_NotVat
                               ON ObjectBoolean_NotVat.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_NotVat.DescId = zc_ObjectBoolean_Contract_NotVat()
       --��� �������� ����
       LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                               ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()
       --����������� ������ ���������
       LEFT JOIN ObjectBoolean AS ObjectBoolean_MarketNot
                               ON ObjectBoolean_MarketNot.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_MarketNot.DescId = zc_ObjectBoolean_Contract_MarketNot()
       --�������� ������ ��� ���
       LEFT JOIN ObjectBoolean AS ObjectBoolean_isWMS
                               ON ObjectBoolean_isWMS.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_isWMS.DescId = zc_ObjectBoolean_Contract_isWMS()
       --����
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                               ON ObjectBoolean_Guide_Irna.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

       --���� ���������� ��������
       LEFT JOIN ObjectDate AS ObjectDate_Signing
                            ON ObjectDate_Signing.ObjectId = Object_Contract.Id
                           AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                           AND Object_Contract.ValueData <> '-'
       --���������� ��������� �� ��������
       LEFT JOIN ObjectFloat AS ObjectFloat_DocumentCount
                             ON ObjectFloat_DocumentCount.ObjectId = Object_Contract.Id
                            AND ObjectFloat_DocumentCount.DescId = zc_ObjectFloat_Contract_DocumentCount()
       --���� ���������� ���������
       LEFT JOIN ObjectDate AS ObjectDate_Document
                            ON ObjectDate_Document.ObjectId = Object_Contract.Id
                           AND ObjectDate_Document.DescId = zc_ObjectDate_Contract_Document()
       --���-�� ���� ��� ������� ���������
       LEFT JOIN ObjectFloat AS ObjectFloat_DayTaxSummary
                             ON ObjectFloat_DayTaxSummary.ObjectId = Object_Contract.Id
                            AND ObjectFloat_DayTaxSummary.DescId = zc_ObjectFloat_Contract_DayTaxSummary()
       --� �������������
       LEFT JOIN ObjectString AS ObjectString_InvNumberArchive
                              ON ObjectString_InvNumberArchive.ObjectId = Object_Contract.Id
                             AND ObjectString_InvNumberArchive.DescId = zc_objectString_Contract_InvNumberArchive()
       --����������
       LEFT JOIN ObjectString AS ObjectString_Comment
                              ON ObjectString_Comment.ObjectId = Object_Contract.Id
                             AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
       --��������� ���� (���.������)
       LEFT JOIN ObjectString AS ObjectString_BankAccount
                              ON ObjectString_BankAccount.ObjectId = Object_Contract.Id
                             AND ObjectString_BankAccount.DescId = zc_objectString_Contract_BankAccount()
       --��������� ���� (����������)
       LEFT JOIN ObjectString AS ObjectString_BankAccountPartner
                              ON ObjectString_BankAccountPartner.ObjectId = Object_Contract.Id
                             AND ObjectString_BankAccountPartner.DescId = zc_objectString_Contract_BankAccountPartner()
       --��� GLN
       LEFT JOIN ObjectString AS ObjectString_GLNCode
                              ON ObjectString_GLNCode.ObjectId = Object_Contract.Id
                             AND ObjectString_GLNCode.DescId = zc_objectString_Contract_GLNCode()
       --��� ����������
       LEFT JOIN ObjectString AS ObjectString_PartnerCode
                              ON ObjectString_PartnerCode.ObjectId = Object_Contract.Id
                             AND ObjectString_PartnerCode.DescId = zc_objectString_Contract_PartnerCode() 
       --���� ������ �����
       LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                            ON ObjectDate_StartPromo.ObjectId = Object_Contract.Id
                           AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Contract_StartPromo()
       --���� ��������� �����
       LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                            ON ObjectDate_EndPromo.ObjectId = Object_Contract.Id
                           AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Contract_EndPromo()

  WHERE Object_Contract.DescId = zc_Object_Contract();
 ;

ALTER TABLE _bi_Guide_Contract_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.05.25         *
*/

-- ����
-- SELECT * FROM _bi_Guide_Contract_View
