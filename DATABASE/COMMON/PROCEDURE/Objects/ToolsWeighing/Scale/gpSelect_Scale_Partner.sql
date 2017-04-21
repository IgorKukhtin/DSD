-- Function: gpSelect_Scale_Partner()

DROP FUNCTION IF EXISTS gpSelect_Scale_Partner (Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_Partner (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_Partner (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Partner(
    IN inIsGoodsComplete Boolean  , -- ����� ��/������������/�������� or �������
    IN inBranchCode      Integer  , --
    IN inSession         TVarChar   -- ������ ������������
)
RETURNS TABLE (PartnerId     Integer
             , PartnerCode   Integer
             , PartnerName   TVarChar
             , JuridicalName TVarChar
             , PaidKindId    Integer
             , PaidKindName  TVarChar
             , ContractId    Integer, ContractCode      Integer, ContractNumber    TVarChar, ContractTagName TVarChar
             , InfoMoneyId   Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , ChangePercent TFloat
             , ChangePercentAmount TFloat

             , isEdiOrdspr   Boolean
             , isEdiInvoice  Boolean
             , isEdiDesadv   Boolean

             , isMovement    Boolean, CountMovement   TFloat   -- ���������
             , isAccount     Boolean, CountAccount    TFloat   -- ����
             , isTransport   Boolean, CountTransport  TFloat   -- ���
             , isQuality     Boolean, CountQuality    TFloat   -- ������������
             , isPack        Boolean, CountPack       TFloat   -- �����������
             , isSpec        Boolean, CountSpec       TFloat   -- ������������
             , isTax         Boolean, CountTax        TFloat   -- ���������

             , ObjectDescId   Integer
             , MovementDescId Integer
             , ItemName       TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Scale_Partner());
   vbUserId:= lpGetUserBySession (inSession);


   -- ������������ ������� �������
   vbObjectId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId), 0);
   vbBranchId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), 0);
   vbIsConstraint:= vbObjectId_Constraint > 0 OR vbBranchId_Constraint > 0;


    -- ���������
    RETURN QUERY
       WITH tmpInfoMoney AS (-- 1.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Income() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                               AND inIsGoodsComplete = FALSE
                               AND inBranchCode     <> 301
                            UNION
                             -- 1.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Income() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700() -- ������������� + ������
                                                                                , zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                                                                                , zc_Enum_InfoMoneyDestination_21000() -- ������������� + �����
                                                                                , zc_Enum_InfoMoneyDestination_21100() -- ������������� + �������
                                                                                 )
                               AND inIsGoodsComplete = TRUE
                            UNION
                             -- 2.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Sale() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                                                                , zc_Enum_InfoMoneyDestination_30300() -- ������ + �����������
                                                                                 )
                               AND inIsGoodsComplete = FALSE
                               AND inBranchCode     <> 301
                            UNION
                             -- 2.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Sale() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE (View_InfoMoney_find.InfoMoneyId IN (zc_Enum_InfoMoney_30101()) -- ������ + ��������� + ������� ���������
                                 OR View_InfoMoney_find.InfoMoneyId IN (zc_Enum_InfoMoney_30103()) -- ������ + ��������� + ����
                                 OR View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30300() -- ������ + �����������
                                                                                  )
                                   )
                               AND inIsGoodsComplete = TRUE
                            /*UNION
                             -- 2.2.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Sale() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                                                                 )
                               AND inIsGoodsComplete = TRUE
                            */
                            UNION
                             -- 3.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Income() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����
                                                                                , zc_Enum_InfoMoneyDestination_20200() -- ������ ���
                                                                                , zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                                                                , zc_Enum_InfoMoneyDestination_20600() -- ������ ���������
                                                                                 )
                               AND inIsGoodsComplete = FALSE
                               AND inBranchCode      = 301
                            )
         , tmpContractPartner AS (SELECT ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
                                       , ObjectLink_ContractPartner_Partner.ChildObjectId  AS PartnerId
                                       , ObjectLink_Partner_Juridical.ChildObjectId        AS JuridicalId
                                  FROM ObjectLink AS ObjectLink_ContractPartner_Partner
                                       INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                                                  AND Object_ContractPartner.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                             ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                                            AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                                            AND ObjectLink_ContractPartner_Contract.ChildObjectId >0
                                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                            ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_ContractPartner_Partner.ChildObjectId
                                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  WHERE ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                    AND ObjectLink_ContractPartner_Partner.ChildObjectId >0
                                 )
          , tmpPartner AS (SELECT DISTINCT
                                  Object_Partner.Id         AS PartnerId
                                , Object_Partner.ObjectCode AS PartnerCode
                                , Object_Partner.ValueData  AS PartnerName
                                , View_Contract.JuridicalId AS JuridicalId
                                , View_Contract.PaidKindId  AS PaidKindId
                                  /*-- ��������������, �.�. � ����� ����� ������ ��� ��� ��-������, ��� ��-����������
                                , CASE WHEN tmpInfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- �������� �����
                                            THEN zc_Enum_InfoMoney_10101() -- �������� ����� + ������ ����� + ����� ���
                                       WHEN tmpInfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- ������ !!!�� ������, �.�. ���� ����� ������������ OR!!!
                                        AND tmpInfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������ + ��������� + ������� ���������
                                            THEN zc_Enum_InfoMoney_30101()
                                       ELSE tmpInfoMoney.InfoMoneyId
                                  END AS InfoMoneyId*/
                                , tmpInfoMoney.InfoMoneyId
                                , tmpInfoMoney.MovementDescId
                                , (View_Contract.ContractId) AS ContractId
                           FROM tmpInfoMoney
                                LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.InfoMoneyId = tmpInfoMoney.InfoMoneyId
                                                                               AND View_Contract.isErased = FALSE
                                                                               AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                LEFT JOIN tmpContractPartner ON tmpContractPartner.ContractId = View_Contract.ContractId
                                                            AND tmpContractPartner.JuridicalId = View_Contract.JuridicalId
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ChildObjectId = View_Contract.JuridicalId
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                    AND tmpContractPartner.ContractId IS NULL
                                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (tmpContractPartner.PartnerId, ObjectLink_Partner_Juridical.ObjectId)

                                LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                     ON ObjectLink_Juridical_JuridicalGroup.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

                                LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                     ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                                                    AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                                                     ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                                                    AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_PersonalTrade
                                                     ON ObjectLink_Unit_Branch_PersonalTrade.ObjectId = ObjectLink_PersonalTrade_Unit.ChildObjectId
                                                    AND ObjectLink_Unit_Branch_PersonalTrade.DescId = zc_ObjectLink_Unit_Branch()

                           WHERE Object_Partner.IsErased = FALSE
                             AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
                                  OR ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = vbBranchId_Constraint
                                  OR vbIsConstraint = FALSE
                                 )
                           /*GROUP BY Object_Partner.Id
                                  , Object_Partner.ObjectCode
                                  , Object_Partner.ValueData
                                  , View_Contract.JuridicalId
                                  , View_Contract.PaidKindId
                                  , tmpInfoMoney.InfoMoneyId
                                  , tmpInfoMoney.MovementDescId*/
                          )
          , tmpPrintKindItem AS (SELECT * FROM lpSelect_Object_PrintKindItem())

       SELECT tmpPartner.PartnerId
            , tmpPartner.PartnerCode
            , tmpPartner.PartnerName
            , Object_Juridical.ValueData           AS JuridicalName
            , Object_PaidKind.Id                   AS PaidKindId
            , Object_PaidKind.ValueData            AS PaidKindName

            , Object_Contract_View.ContractId      AS ContractId
            , Object_Contract_View.ContractCode    AS ContractCode
            , Object_Contract_View.InvNumber       AS ContractNumber
            , Object_Contract_View.ContractTagName AS ContractTagName

            , tmpPartner.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , Object_ContractCondition_PercentView.ChangePercent :: TFloat AS ChangePercent
            , CASE WHEN View_InfoMoney.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000() -- �������� �����
                                                          , zc_Enum_InfoMoneyGroup_20000() -- �������������
                                                           )
                        THEN 0 -- !!!����������!!!!
                   WHEN inIsGoodsComplete = FALSE
                    AND tmpPartner.JuridicalId = 15384 -- Գ����� �����-��������� ������� ���� ��������
                        THEN 1 -- ���������� �����, �����������
                   WHEN inIsGoodsComplete = FALSE
                        THEN 0 -- ���������� �����, ���
                   WHEN tmpPartner.PartnerCode IN (12345678) -- ???
                        THEN 1 -- ���������� ��, ����� ���� ����� ������������
                   ELSE 1 -- ���������� ��, ���
              END :: TFloat AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpPrintKindItem.isPack = TRUE OR tmpPrintKindItem.isSpec = TRUE THEN COALESCE (tmpPrintKindItem.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , CASE WHEN tmpPrintKindItem.CountMovement > 0 THEN tmpPrintKindItem.CountMovement ELSE 2 END :: TFloat AS CountMovement
            , COALESCE (tmpPrintKindItem.isAccount, FALSE)   :: Boolean AS isAccount,   COALESCE (tmpPrintKindItem.CountAccount, 0)   :: TFloat AS CountAccount
            , COALESCE (tmpPrintKindItem.isTransport, FALSE) :: Boolean AS isTransport, COALESCE (tmpPrintKindItem.CountTransport, 0) :: TFloat AS CountTransport
            , COALESCE (tmpPrintKindItem.isQuality, FALSE)   :: Boolean AS isQuality  , COALESCE (tmpPrintKindItem.CountQuality, 0)   :: TFloat AS CountQuality
            , COALESCE (tmpPrintKindItem.isPack, FALSE)      :: Boolean AS isPack     , COALESCE (tmpPrintKindItem.CountPack, 0)      :: TFloat AS CountPack
            , COALESCE (tmpPrintKindItem.isSpec, FALSE)      :: Boolean AS isSpec     , COALESCE (tmpPrintKindItem.CountSpec, 0)      :: TFloat AS CountSpec
            , COALESCE (tmpPrintKindItem.isTax, FALSE)       :: Boolean AS isTax      , COALESCE (tmpPrintKindItem.CountTax, 0)       :: TFloat AS CountTax

            , ObjectDesc.Id AS ObjectDescId
            , tmpPartner.MovementDescId
            , ObjectDesc.ItemName

       FROM tmpPartner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Partner()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectLink AS ObjectLink_Retail_PrintKindItem
                                 ON ObjectLink_Retail_PrintKindItem.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                AND ObjectLink_Retail_PrintKindItem.DescId = zc_ObjectLink_Retail_PrintKindItem()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_PrintKindItem
                                 ON ObjectLink_Juridical_PrintKindItem.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_PrintKindItem.DescId = zc_ObjectLink_Juridical_PrintKindItem()
            LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id = CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId > 0 THEN ObjectLink_Retail_PrintKindItem.ChildObjectId ELSE ObjectLink_Juridical_PrintKindItem.ChildObjectId END

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpPartner.InfoMoneyId
            LEFT JOIN Object_ContractCondition_PercentView ON Object_ContractCondition_PercentView.ContractId = tmpPartner.ContractId

            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = tmpPartner.ContractId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpPartner.PaidKindId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpPartner.JuridicalId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
                                   AND 1=0 -- �����, �.�. �������� �� ����� ������ � EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
                                   AND 1=0 -- �����, �.�. �������� �� ����� ������ � EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
                                   AND 1=0 -- �����, �.�. �������� �� ����� ������ � EDI
      UNION ALL
       SELECT Object_ArticleLoss.Id          AS PartnerId
            , Object_ArticleLoss.ObjectCode  AS PartnerCode
            , Object_ArticleLoss.ValueData   AS PartnerName
            , '' :: TVarChar  AS JuridicalName
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , NULL :: Integer AS ContractId
            , View_ProfitLossDirection.ProfitLossDirectionCode             AS ContractCode
            , View_ProfitLossDirection.ProfitLossDirectionCode :: TVarChar AS ContractNumber
            , View_ProfitLossDirection.ProfitLossDirectionName             AS ContractTagName

            , NULL :: Integer                     AS InfoMoneyId
            , Object_InfoMoney_View.InfoMoneyCode AS InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyName AS InfoMoneyName

            , NULL :: TFloat AS ChangePercent
            , NULL :: TFloat AS ChangePercentAmount

            , FALSE       :: Boolean AS isEdiOrdspr
            , FALSE       :: Boolean AS isEdiInvoice
            , FALSE       :: Boolean AS isEdiDesadv

            , TRUE        :: Boolean AS isMovement,  2 :: TFloat AS CountMovement
            , FALSE       :: Boolean AS isAccount,   0 :: TFloat AS CountAccount
            , FALSE       :: Boolean AS isTransport, 0 :: TFloat AS CountTransport
            , FALSE       :: Boolean AS isQuality,   0 :: TFloat AS CountQuality
            , FALSE       :: Boolean AS isPack   ,   0 :: TFloat AS CountPack
            , FALSE       :: Boolean AS isSpec   ,   0 :: TFloat AS CountSpec
            , FALSE       :: Boolean AS isTax    ,   0 :: TFloat AS CountTax

            , ObjectDesc.Id AS ObjectDescId
            , zc_Movement_Loss() AS MovementDescId
            , ObjectDesc.ItemName

       FROM Object AS Object_ArticleLoss
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_ArticleLoss.DescId

            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney 
                                 ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_ArticleLoss_InfoMoney.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                 ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
                                AND ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId > 0
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId

       WHERE Object_ArticleLoss.DescId = zc_Object_ArticleLoss()
         AND Object_ArticleLoss.isErased = FALSE

      UNION ALL
       SELECT Object_Unit.Id          AS PartnerId
            , Object_Unit.ObjectCode  AS PartnerCode
            , Object_Unit.ValueData   AS PartnerName
            , Object_Branch.ObjectCode :: TVarChar AS JuridicalName -- ��� ����������
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , NULL :: Integer AS ContractId
            , View_AccountDirection.AccountDirectionCode             AS ContractCode
            , View_AccountDirection.AccountDirectionCode :: TVarChar AS ContractNumber
            , View_AccountDirection.AccountDirectionName             AS ContractTagName

            , NULL :: Integer                     AS InfoMoneyId
            , Object_Branch.ObjectCode            AS InfoMoneyCode
            , Object_Branch.ValueData             AS InfoMoneyName

            , NULL :: TFloat AS ChangePercent
            , CASE WHEN Object_Unit.Id IN (301309 -- ����� �� �.���������
                                         , 346093 -- ����� �� �.������
                                         , 8413   -- 22031	����� �� �.������ ���	������ ��.���
                                         , 8417   -- 22051	����� �� �.�������� (������)	������ �������� (������)
                                         , 8425   -- 22091	����� �� �.�������	������ �������
                                         , 8415   -- 22041	����� �� �.�������� (����������)	������ �������� (����������)
                                          )
                        THEN 0
                        ELSE 0
              END :: TFloat AS ChangePercentAmount

            , FALSE       :: Boolean AS isEdiOrdspr
            , FALSE       :: Boolean AS isEdiInvoice
            , FALSE       :: Boolean AS isEdiDesadv

            , TRUE        :: Boolean AS isMovement,  2 :: TFloat AS CountMovement
            , FALSE       :: Boolean AS isAccount,   0 :: TFloat AS CountAccount
            , FALSE       :: Boolean AS isTransport, 0 :: TFloat AS CountTransport
            , FALSE       :: Boolean AS isQuality,   0 :: TFloat AS CountQuality
            , FALSE       :: Boolean AS isPack   ,   0 :: TFloat AS CountPack
            , FALSE       :: Boolean AS isSpec   ,   0 :: TFloat AS CountSpec
            , FALSE       :: Boolean AS isTax    ,   0 :: TFloat AS CountTax

            , ObjectDesc.Id             AS ObjectDescId
            , zc_Movement_SendOnPrice() AS MovementDescId
            , ObjectDesc.ItemName

       FROM Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                 ON ObjectLink_Unit_AccountDirection.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
            LEFT JOIN Object_AccountDirection_View AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = ObjectLink_Unit_AccountDirection.ChildObjectId

       WHERE Object_Unit.DescId = zc_Object_Unit()
         AND Object_Unit.isErased = FALSE
/*         AND (ObjectLink_Unit_AccountDirection.ChildObjectId = zc_Enum_AccountDirection_20700() -- ������ + �� ��������
           OR ((ObjectLink_Unit_Parent.ChildObjectId = 8460 -- ������ - �������� �����
                OR Object_Unit.Id = 8459) -- ����� ����������
               AND vbBranchId_Constraint > 0
             ))*/
         AND ((Object_Unit.Id IN (301309 -- 22121	����� �� �.���������	������ ���������
                                , 309599 -- 22122	����� ��������� �.���������	������ ���������
                                , 8411   -- 22021	����� �� �.����	������ ����
                                , 428365 -- 22022	����� ��������� �.����	������ ����
                                , 8413   -- 22031	����� �� �.������ ���	������ ��.���
                                , 428366 -- 22032	����� ��������� �.������ ���	������ ��.���
                                , 8417   -- 22051	����� �� �.�������� (������)	������ �������� (������)
                                , 428364 -- 22052	����� ��������� �.�������� (������)	������ �������� (������)
                                , 346093 -- 22081	����� �� �.������	������ ������
                                , 346094 -- 22082	����� ��������� �.������	������ ������
                                , 8425   -- 22091	����� �� �.�������	������ �������
                                , 409007 -- 22092	����� ��������� �.�������	������ �������
                                , 8415   -- 22041	����� �� �.�������� (����������)	������ �������� (����������)
                                , 428363 -- 22042	����� ��������� �.�������� (����������)	������ �������� (����������)
                                )
            AND (vbBranchId_Constraint = 0
              OR vbUserId = zfCalc_UserAdmin() :: Integer)
              )
           OR ((ObjectLink_Unit_Parent.ChildObjectId = 8460 -- ������ - �������� �����
                OR Object_Unit.Id = 8459) -- ����� ����������
               AND (vbBranchId_Constraint > 0
                OR vbUserId = zfCalc_UserAdmin() :: Integer))
              )

       ORDER BY 4 -- Object_Juridical.ValueData
              , 3 -- tmpPartner.PartnerName
              , 2 -- tmpPartner.PartnerCode
              , 12 -- View_InfoMoney.InfoMoneyCode
              , 8 -- Object_Contract_View.ContractCode
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.01.15                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Scale_Partner (inIsGoodsComplete:= FALSE, inBranchCode:= 301, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Scale_Partner (inIsGoodsComplete:= TRUE, inBranchCode:= 1, inSession:= zfCalc_UserAdmin())
