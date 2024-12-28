-- Function: gpSelect_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inPeriodForOperDate Boolean ,
    IN inIsAllPartner      Boolean ,   -- ���������� �� ������������
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id               Integer     --�������������
             , InvNumber        Integer     --����� ���������
             , OperDate         TDateTime   --���� ���������
             , StatusCode       Integer     --��� �������
             , StatusName       TVarChar    --������      
             , PaidKindId Integer, PaidKindName TVarChar
             , PromoKindId      Integer     --��� �����
             , PromoKindName    TVarChar    --��� �����
             , PromoStateKindId Integer     -- ��������� �����
             , PromoStateKindName TVarChar  -- ��������� �����
             , PriceListId      Integer     --����� ����
             , PriceListName    TVarChar    --����� ����
             , StartPromo       TDateTime   --���� ������ �����
             , EndPromo         TDateTime   --���� ��������� �����
             , StartSale        TDateTime   --���� ������ �������� �� ��������� ����
             , EndSale          TDateTime   --���� ��������� �������� �� ��������� ����
             , EndReturn        TDateTime   --���� ��������� ��������� �� ��������� ����
             , OperDateStart    TDateTime   --���� ������ ����. ������ �� �����
             , OperDateEnd      TDateTime   --���� ��������� ����. ������ �� �����
             , MonthPromo       TDateTime   --����� �����
             , CheckDate        TDateTime   --���� ������������ 
             , MessageDate      TDateTime   --����/����� ��������� ��������
             , ServiceDate      TDateTime   -- 	����� ������� �/�
             , CostPromo        TFloat      --��������� ������� � �����
             , ChangePercent    TFloat      --(-)% ������ (+)% ������� �� ��������

             , CountDayPromo    Integer
             , CountDaySale     Integer
             , CountDayOperDate Integer

             , Comment          TVarChar    --����������
             , CommentMain      TVarChar    --���������� (�����)
             , UnitId           Integer     --�������������
             , UnitName         TVarChar    --�������������
             , PersonalTradeId  Integer     --������������� ������������� ������������� ������
             , PersonalTradeName TVarChar   --������������� ������������� ������������� ������
             , PersonalId       Integer     --������������� ������������� �������������� ������
             , PersonalName     TVarChar    --������������� ������������� �������������� ������
             , SignInternalId   Integer
             , SignInternalName TVarChar
             , PartnerName      TVarChar     --�������
             , PartnerDescName  TVarChar     --��� ��������
             , ContractName     TVarChar     --� ��������
             , ContractTagName  TVarChar     --������� ��������
             , RetailName       TVarChar     -- "����" - STRING_AGG, ���� ���� ���, ����� �� ����
             , DayCount         Integer     --
             , isFirst          Boolean      --������ �������� � ������ (��� ������������� ������)
             , ChangePercentName TVarChar    -- ������ �� ��������
             , isPromo          Boolean     --����� (��/���)  
             , isCOst           Boolean     --�������
             , Checked          Boolean     --����������� (��/���)
             , isTaxPromo       Boolean     -- ����� % ������
             , isTaxPromo_Condition  Boolean     -- ����� % �����������
             , isPromoStateKind_Head Boolean
             , isPromoStateKind_Main Boolean
             , isPromoStateKind   Boolean      -- ��������� ��� ���������
             , Color_PromoStateKind Integer
             , strSign        TVarChar -- ��� �������������. - ���� ��. �������
             , strSignNo      TVarChar -- ��� �������������. - ��������� ��. �������
             , isDetail   Boolean
             , InsertName TVarChar
             , InsertDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- ���������
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
           , tmpMovement AS (SELECT Movement_Promo.*
                                  , MovementDate_StartSale.ValueData            AS StartSale
                                  , MovementDate_EndSale.ValueData              AS EndSale
                             FROM Movement AS Movement_Promo
                                  INNER JOIN tmpStatus ON Movement_Promo.StatusId = tmpStatus.StatusId

                                  LEFT JOIN MovementDate AS MovementDate_StartSale
                                                          ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                         AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                  LEFT JOIN MovementDate AS MovementDate_EndSale
                                                          ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                         AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

                             WHERE Movement_Promo.DescId = zc_Movement_Promo()
                               AND ( (inPeriodForOperDate = TRUE AND Movement_Promo.OperDate BETWEEN inStartDate AND inEndDate)
                                  OR (inPeriodForOperDate = FALSE AND (MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                                                                       OR inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                                                                      )
                                     )
                                   )
                            )
           , tmpMovement_PromoPartner AS (SELECT Movement_PromoPartner.Id                                                 --�������������
                                               , Movement_PromoPartner.StatusId
                                               , Object_Status.ObjectCode               AS StatusCode
                                               , Object_Status.ValueData                AS StatusName
                                               , Movement_PromoPartner.ParentId                                    --������ �� �������� �������� <�����> (zc_Movement_Promo)
                                               , Object_Partner.ValueData               AS PartnerName             --���������� ��� �����
                                               , ObjectDesc_Partner.ItemName            AS PartnerDescName         --��� ���������� ��� �����
                                               , Object_Contract.ValueData              AS ContractName            --������������ ���������
                                               , Object_ContractTag.ValueData           AS ContractTagName         --������� ���������
                                               , COALESCE (Object_Retail.ValueData, Object_Juridical.ValueData)   AS RetailName      --������������ ������� <�������� ����> ��� ��.����

                                          FROM tmpMovement
                                               LEFT JOIN Movement AS Movement_PromoPartner ON Movement_PromoPartner.ParentId = tmpMovement.Id
                                                                                          AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                                                                          AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoPartner.StatusId

                                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                            ON MovementLinkObject_Partner.MovementId = Movement_PromoPartner.Id
                                                                           AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
                                               LEFT OUTER JOIN ObjectDesc AS ObjectDesc_Partner ON ObjectDesc_Partner.Id = Object_Partner.DescId

                                               LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                          ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                         AND Object_Partner.DescId = zc_Object_Partner()
                                               LEFT OUTER JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id)
                                       
                                               LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                                          ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id)
                                                                         AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                               LEFT OUTER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                            ON MovementLinkObject_Contract.MovementId = Movement_PromoPartner.Id
                                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                                               LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                                                    ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                                                   AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                                               LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                                         )
           , tmpStrRetail AS (SELECT tmpMovement_PromoPartner.ParentId
                                   , STRING_AGG (DISTINCT tmpMovement_PromoPartner.RetailName, ', ') ::TVarChar AS RetailName
                              FROM tmpMovement_PromoPartner
                              GROUP BY tmpMovement_PromoPartner.ParentId
                              )

           , tmpMI_Detail AS (SELECT DISTINCT tmpMovement.Id AS MovementId
                              FROM tmpMovement
                                   INNER JOIN MovementItem AS MI_Detail
                                                           ON MI_Detail.MovementId = tmpMovement.Id
                                                          AND MI_Detail.DescId     = zc_MI_Detail()
                                                          AND MI_Detail.isErased   = FALSE
                             )
           , tmpMI_Child AS (SELECT MI_Child.MovementId
                                  , Object_ChangePercent.ValueData  AS ChangePercentName
                             FROM tmpMovement
                                  LEFT JOIN MovementItem AS MI_Child
                                                         ON MI_Child.MovementId = tmpMovement.Id
                                                        AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- ��� ����� % ������ �� ��������
                                                        AND MI_Child.isErased   = FALSE
                                  LEFT JOIN Object AS Object_ChangePercent ON Object_ChangePercent.Id = MI_Child.ObjectId
                           )
           , tmpSign AS (SELECT tmpMovement.Id
                              , tmpSign.strSign
                              , tmpSign.strSignNo
                              , tmpSign.SignInternalId
                         FROM tmpMovement
                              LEFT JOIN lpSelect_MI_Sign (inMovementId:= tmpMovement.Id ) AS tmpSign ON tmpSign.Id = tmpMovement.Id
                         )
        -- ���������
        SELECT Movement_Promo.Id                                                 --�������������
             , Movement_Promo.InvNumber :: Integer                               --����� ���������
             , Movement_Promo.OperDate                                           --���� ���������
             , CASE WHEN Movement_PromoPartner.StatusId = zc_Enum_Status_Erased() THEN Movement_PromoPartner.StatusCode ELSE Object_Status.ObjectCode END :: Integer  AS StatusCode
             , CASE WHEN Movement_PromoPartner.StatusId = zc_Enum_Status_Erased() THEN Movement_PromoPartner.StatusName ELSE Object_Status.ValueData END :: TVarChar AS StatusName   
             , Object_PaidKind.Id                          AS PaidKindId
             , Object_PaidKind.ValueData                   AS PaidKindName
             , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --��� �����
             , Object_PromoKind.ValueData                  AS PromoKindName      --��� �����
             , Object_PromoStateKind.Id                    AS PromoStateKindId        --��������� �����
             , Object_PromoStateKind.ValueData             AS PromoStateKindName      --��������� �����
             , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --����� ����
             , Object_PriceList.ValueData                  AS PriceListName      --����� ����
             , MovementDate_StartPromo.ValueData           AS StartPromo         --���� ������ �����
             , MovementDate_EndPromo.ValueData             AS EndPromo           --���� ��������� �����
             , Movement_Promo.StartSale                    AS StartSale          --���� ������ �������� �� ��������� ����
             , Movement_Promo.EndSale                      AS EndSale            --���� ��������� �������� �� ��������� ����
             , MovementDate_EndReturn.ValueData            AS EndReturn          --���� ��������� ��������� �� ��������� ����
             , MovementDate_OperDateStart.ValueData        AS OperDateStart      --���� ������ ����. ������ �� �����
             , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --���� ��������� ����. ������ �� �����
             , MovementDate_Month.ValueData                AS MonthPromo         -- ����� �����
             , MovementDate_CheckDate.ValueData            AS CheckDate          --���� ������������
             , MovementDate_MessageDate.ValueData          AS MessageDate        --����/����� ��������� �������� 
             , MovementDate_ServiceDate.ValueData          AS ServiceDate        --����� ������� �/�
             , MovementFloat_CostPromo.ValueData           AS CostPromo          --��������� ������� � �����
             , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% ������ (+)% ������� �� ��������

             , (DATE_PART ('DAY', AGE (MovementDate_EndPromo.ValueData, MovementDate_StartPromo.ValueData) )+1)      ::Integer AS CountDayPromo
             , (DATE_PART ('DAY', AGE (Movement_Promo.EndSale, Movement_Promo.StartSale) )+1)                        ::Integer AS CountDaySale
             , (DATE_PART ('DAY', AGE (MovementDate_OperDateEnd.ValueData, MovementDate_OperDateStart.ValueData) )+1)::Integer AS CountDayOperDate

             , MovementString_Comment.ValueData            AS Comment            --����������
             , MovementString_CommentMain.ValueData        AS CommentMain        --���������� (�����)
             , MovementLinkObject_Unit.ObjectId            AS UnitId             --�������������
             , Object_Unit.ValueData                       AS UnitName           --�������������
             , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --������������� ������������� ������������� ������
             , Object_PersonalTrade.ValueData              AS PersonalTradeName  --������������� ������������� ������������� ������
             , MovementLinkObject_Personal.ObjectId        AS PersonalId         --������������� ������������� �������������� ������
             , Object_Personal.ValueData                   AS PersonalName       --������������� ������������� �������������� ������

             , Object_SignInternal.Id                      AS SignInternalId
             , Object_SignInternal.ValueData               AS SignInternalName

             , Movement_PromoPartner.PartnerName     --�������
             , Movement_PromoPartner.PartnerDescName --��� ��������
             , Movement_PromoPartner.ContractName    --�������� ���������
             , Movement_PromoPartner.ContractTagName --������� ��������
             , COALESCE (Movement_PromoPartner.RetailName, tmpStrRetail.RetailName) :: TVarChar AS RetailName      -- ����/��.����

             , (1 + EXTRACT (DAY FROM (Movement_Promo.EndSale - Movement_Promo.StartSale))) :: Integer AS DayCount

             , CASE
                  WHEN (ROW_NUMBER() OVER(PARTITION BY Movement_Promo.Id ORDER BY Movement_PromoPartner.Id)) = 1
                      THEN TRUE
              ELSE FALSE
              END as IsFirst
             , COALESCE (MI_Child.ChangePercentName, '��')    :: TVarChar AS ChangePercentName

             , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- ����� (��/���) 
             , COALESCE (MovementBoolean_Cost.ValueData, FALSE)    :: Boolean AS isCOst   -- ������� (��/���)
             , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked  -- ����������� (��/���)
             , CASE WHEN MovementBoolean_TaxPromo.ValueData = TRUE  THEN TRUE ELSE FALSE END :: Boolean AS isTaxPromo --
             , CASE WHEN MovementBoolean_TaxPromo.ValueData = FALSE THEN TRUE ELSE FALSE END :: Boolean AS isTaxPromo_Condition  --
               -- ������� - �������� �� ����������
             , CASE WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Head()
                      OR (tmpSign.strSign ILIKE '%��������� �.�.%' AND Object_PromoStateKind.Id NOT IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete()))
                         THEN TRUE
                    ELSE FALSE
               END :: Boolean AS isPromoStateKind_Head

               -- ������� - �������������� ��������
             , CASE WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Main() THEN TRUE ELSE FALSE END :: Boolean AS isPromoStateKind_Main

               -- ��������� ��� ���������
             , CASE WHEN COALESCE (MovementFloat_PromoStateKind.ValueData,0) = 1 THEN  TRUE ELSE FALSE END :: Boolean AS isPromoStateKind  

               -- ����
/*
- � ������ �������� �� ���������� - ���������� ������ ������-������
- � ������ �������������� �������� - ���������� ������ ������-������
- ������� ��� ����������� - ���������� ������ ��������� (������������)
- ����������, �� ������ ������ �� �������� - ���������� ������ ������-�������
- ������� ���������� ������ ������� ������ 
- � ������ ����� ���������� - ���������� ������ ������-������� ������
*/
             , CASE WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Head() OR Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Main() THEN zc_Color_Yelow()     -- � ������ �������� �� ���������� ��� � ������ �������������� ��������
                    WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Return() THEN 8435455                                                                        --  ��������� (������������)
                    WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Complete() AND Movement_Promo.StatusId = zc_Enum_Status_UnComplete() THEN zc_Color_Aqua()    --�������
                    WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Canceled() THEN zc_Color_Red()   -- �������
                    WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Start() THEN 13041606 --zc_Color_Lime()     -- �������
                    -- ��� �����
                    ELSE zc_Color_White()
               END AS Color_PromoStateKind

/*             , CASE WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Head()
                      OR (tmpSign.strSign ILIKE '%��������� �.�.%' AND Object_PromoStateKind.Id NOT IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete()))
                        -- �������������� �������� - ������ / �������
                        THEN CASE WHEN COALESCE (MovementFloat_PromoStateKind.ValueData, 0) = 1 THEN zc_Color_Yelow() ELSE zc_Color_Pink() END

                    WHEN Object_PromoStateKind.Id = zc_Enum_PromoStateKind_Main()
                         -- �������������� �������� - ������� / �������
                         THEN CASE WHEN COALESCE (MovementFloat_PromoStateKind.ValueData, 0) = 1 THEN zc_Color_Lime() ELSE zc_Color_Aqua() END

                    -- ��� �����
                    ELSE zc_Color_White()

               END AS Color_PromoStateKind
*/
             , tmpSign.strSign
             , tmpSign.strSignNo
             
             , CASE WHEN MI_Detail.MovementId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isDetail

             , Object_User.ValueData                  AS InsertName
             , MovementDate_Insert.ValueData          AS InsertDate

        FROM tmpMovement AS Movement_Promo
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Promo.StatusId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoKind
                                          ON MovementLinkObject_PromoKind.MovementId = Movement_Promo.Id
                                         AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
             LEFT JOIN Object AS Object_PromoKind
                              ON Object_PromoKind.Id = MovementLinkObject_PromoKind.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                          ON MovementLinkObject_PriceList.MovementId = Movement_Promo.Id
                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
             LEFT JOIN Object AS Object_PriceList
                              ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                          ON MovementLinkObject_PaidKind.MovementId = Movement_Promo.Id
                                         AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                     ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                                    AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                     ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                                    AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

             LEFT JOIN MovementDate AS MovementDate_EndReturn
                                    ON MovementDate_EndReturn.MovementId = Movement_Promo.Id
                                   AND MovementDate_EndReturn.DescId = zc_MovementDate_EndReturn()

             LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                     ON MovementDate_OperDateStart.MovementId = Movement_Promo.Id
                                    AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
             LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                     ON MovementDate_OperDateEnd.MovementId = Movement_Promo.Id
                                    AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

             LEFT JOIN MovementDate AS MovementDate_Month
                                    ON MovementDate_Month.MovementId = Movement_Promo.Id
                                   AND MovementDate_Month.DescId = zc_MovementDate_Month()

             LEFT JOIN MovementDate AS MovementDate_CheckDate
                                    ON MovementDate_CheckDate.MovementId = Movement_Promo.Id
                                   AND MovementDate_CheckDate.DescId = zc_MovementDate_Check()

             LEFT JOIN MovementDate AS MovementDate_MessageDate
                                    ON MovementDate_MessageDate.MovementId = Movement_Promo.Id
                                   AND MovementDate_MessageDate.DescId = zc_MovementDate_Message()

             LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                    ON MovementDate_ServiceDate.MovementId = Movement_Promo.Id
                                   AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

             LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                     ON MovementFloat_CostPromo.MovementId = Movement_Promo.Id
                                    AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()

             LEFT JOIN MovementFloat AS MovementFloat_PromoStateKind
                                     ON MovementFloat_PromoStateKind.MovementId = Movement_Promo.Id
                                    AND MovementFloat_PromoStateKind.DescId = zc_MovementFloat_PromoStateKind()

             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                     ON MovementFloat_ChangePercent.MovementId = Movement_Promo.Id
                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_Promo.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementString AS MovementString_CommentMain
                                      ON MovementString_CommentMain.MovementId = Movement_Promo.Id
                                     AND MovementString_CommentMain.DescId = zc_MovementString_CommentMain()

             LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                       ON MovementBoolean_Checked.MovementId = Movement_Promo.Id
                                      AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

             LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                       ON MovementBoolean_Promo.MovementId = Movement_Promo.Id
                                      AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

             LEFT JOIN MovementBoolean AS MovementBoolean_Cost
                                       ON MovementBoolean_Cost.MovementId = Movement_Promo.Id
                                      AND MovementBoolean_Cost.DescId = zc_MovementBoolean_Cost()

             LEFT JOIN MovementBoolean AS MovementBoolean_TaxPromo
                                       ON MovementBoolean_TaxPromo.MovementId = Movement_Promo.Id
                                      AND MovementBoolean_TaxPromo.DescId = zc_MovementBoolean_TaxPromo()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement_Promo.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_Unit
                              ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement_Promo.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
             LEFT JOIN Object AS Object_PersonalTrade
                              ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                          ON MovementLinkObject_Personal.MovementId = Movement_Promo.Id
                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
             LEFT JOIN Object AS Object_Personal
                              ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                          ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                         AND MovementLinkObject_PromoStateKind.DescId = zc_MovementLinkObject_PromoStateKind()
             LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementLinkObject_PromoStateKind.ObjectId

             LEFT JOIN tmpMovement_PromoPartner AS Movement_PromoPartner
                                                ON Movement_PromoPartner.ParentId = Movement_Promo.Id
                                               AND inIsAllPartner = TRUE

             LEFT JOIN tmpStrRetail ON tmpStrRetail.ParentId = Movement_Promo.Id
                                                

             LEFT JOIN tmpMI_Child AS MI_Child ON MI_Child.MovementId = Movement_Promo.Id
             LEFT JOIN tmpMI_Detail AS MI_Detail ON MI_Detail.MovementId = Movement_Promo.Id

             LEFT JOIN tmpSign ON tmpSign.Id = Movement_Promo.Id   -- ��.�������  --

             LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = tmpSign.SignInternalId

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_Promo.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                          ON MovementLinkObject_Insert.MovementId = Movement_Promo.Id
                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 16.09.22         * zc_MovementDate_Message
 05.10.20         *
 13.07.20         * ChangePercent
 01.04.20         *
 01.08.17         *
 25.07.17         *
 05.10.16         * add inJuridicalBasisId
 27.11.15                                                                        *inPeriodForOperDate
 17.11.15                                                                        *Movement_PromoPartner_View
 13.10.15                                                                        *
*/

-- SELECT * FROM gpSelect_Movement_Promo (inStartDate:= '01.11.2024', inEndDate:= '30.11.2024', inIsErased:= FALSE, inPeriodForOperDate:=TRUE, inIsAllPartner:= False, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
