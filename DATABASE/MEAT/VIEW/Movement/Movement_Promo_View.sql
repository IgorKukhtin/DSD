--

DROP VIEW IF EXISTS Movement_Promo_View;

CREATE OR REPLACE VIEW Movement_Promo_View AS 
    SELECT       
        Movement_Promo.Id                                                 --�������������
      , Movement_Promo.InvNumber :: Integer         AS InvNumber          --����� ���������
      , Movement_Promo.OperDate                                           --���� ���������
      , Object_Status.Id                            AS StatusId           --�� �������
      , Object_Status.ObjectCode                    AS StatusCode         --��� �������
      , Object_Status.ValueData                     AS StatusName         --������
      , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --��� �����
      , Object_PromoKind.ValueData                  AS PromoKindName      --��� �����
      , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --����� ����
      , Object_PriceList.ValueData                  AS PriceListName      --����� ����
      , MovementDate_StartPromo.ValueData           AS StartPromo         --���� ������ �����
      , MovementDate_EndPromo.ValueData             AS EndPromo           --���� ��������� �����
      , MovementDate_StartSale.ValueData            AS StartSale          --���� ������ �������� �� ��������� ����
      , MovementDate_EndSale.ValueData              AS EndSale            --���� ��������� �������� �� ��������� ����
      , MovementDate_EndReturn.ValueData            AS EndReturn          --���� ��������� ��������� �� ��������� ����
      , MovementDate_OperDateStart.ValueData        AS OperDateStart      --���� ������ ����. ������ �� �����
      , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --���� ��������� ����. ������ �� �����
      , MovementFloat_CostPromo.ValueData           AS CostPromo          --��������� ������� � �����
      , MovementString_Comment.ValueData            AS Comment            --����������
      , MovementString_CommentMain.ValueData        AS CommentMain        --���������� (�����)
      , MovementLinkObject_Unit.ObjectId            AS UnitId             --�������������
      , Object_Unit.ValueData                       AS UnitName           --�������������
      , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --������������� ������������� ������������� ������
      , Object_PersonalTrade.ValueData              AS PersonalTradeName  --������������� ������������� ������������� ������
      , MovementLinkObject_Personal.ObjectId        AS PersonalId         --������������� ������������� �������������� ������	
      , Object_Personal.ValueData                   AS PersonalName       --������������� ������������� �������������� ������	
      , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- ����� (��/���)
      , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked  -- ����������� (��/���)
      , DATE_TRUNC ('MONTH', MovementDate_Month.ValueData) :: TDateTime AS MonthPromo         -- ����� �����
      , MovementDate_CheckDate.ValueData            AS CheckDate          --���� ������������

      , Object_PromoStateKind.Id                    AS PromoStateKindId        --��������� �����
      , Object_PromoStateKind.ValueData             AS PromoStateKindName      --��������� �����
      , COALESCE (MovementFloat_PromoStateKind.ValueData,0) ::TFloat  AS PromoStateKind  -- ��������� ��� ���������
      , CASE WHEN COALESCE (MovementFloat_PromoStateKind.ValueData,0) = 1 THEN  TRUE ELSE FALSE END :: Boolean AS isPromoStateKind  -- ��������� ��� ���������
      
      , CASE WHEN MovementBoolean_TaxPromo.ValueData = TRUE  THEN TRUE ELSE FALSE END :: Boolean AS isTaxPromo -- 
      , CASE WHEN MovementBoolean_TaxPromo.ValueData = FALSE THEN TRUE ELSE FALSE END :: Boolean AS isTaxPromo_Condition  --

      , Object_SignInternal.Id                      AS SignInternalId
      , Object_SignInternal.ValueData               AS SignInternalName

      , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% ������ (+)% ������� �� �������� 
      , MovementDate_ServiceDate.ValueData          AS ServiceDate        --����� ������� �/�

      , Object_PaidKind.Id                          AS PaidKindId
      , Object_PaidKind.ValueData                   AS PaidKindName      
      , COALESCE (MovementBoolean_Cost.ValueData, FALSE)    :: Boolean AS isCOst   -- ������� (��/���)      
    FROM Movement AS Movement_Promo 
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
     
        LEFT JOIN MovementDate AS MovementDate_StartPromo
                                ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                               AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                               AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                               
        LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
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
 
        LEFT JOIN MovementDate AS MovementDate_ServiceDate
                               ON MovementDate_ServiceDate.MovementId = Movement_Promo.Id
                              AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                              
        LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                ON MovementFloat_CostPromo.MovementId = Movement_Promo.Id
                               AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()

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

        LEFT JOIN MovementFloat AS MovementFloat_PromoStateKind
                                ON MovementFloat_PromoStateKind.MovementId = Movement_Promo.Id
                               AND MovementFloat_PromoStateKind.DescId = zc_MovementFloat_PromoStateKind()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                     ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_PromoStateKind.DescId = zc_MovementLinkObject_PromoStateKind()
        LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementLinkObject_PromoStateKind.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_SignInternal
                                     ON MovementLinkObject_SignInternal.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_SignInternal.DescId = zc_MovementLinkObject_SignInternal()
        LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = MovementLinkObject_SignInternal.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

        LEFT JOIN MovementBoolean AS MovementBoolean_Cost
                                  ON MovementBoolean_Cost.MovementId = Movement_Promo.Id
                                 AND MovementBoolean_Cost.DescId = zc_MovementBoolean_Cost()

    WHERE Movement_Promo.DescId = zc_Movement_Promo()
   ;

ALTER TABLE Movement_Promo_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 31.10.15                                                         * 
*/

-- ����
-- SELECT * FROM Movement_Promo_View  where id = 2641111
