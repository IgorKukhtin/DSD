-- View: _bi_Guide_Contract_View

 DROP VIEW IF EXISTS _bi_Guide_Contract_View;

-- ���������� �����������
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

  WHERE Object_Contract.DescId = zc_Object_Contract();
 ;

ALTER TABLE _bi_Guide_Contract_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.25         *
*/

-- ����
-- SELECT * FROM _bi_Guide_Contract_View
