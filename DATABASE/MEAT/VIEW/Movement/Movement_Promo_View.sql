DROP VIEW IF EXISTS Movement_Promo_View;

CREATE OR REPLACE VIEW Movement_Promo_View AS 
    SELECT       
        Movement_Promo.Id                                                 --�������������
      , Movement_Promo.InvNumber                                          --����� ���������
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
                                ON MovementDate_StartPromo.MovementId =  Movement_Promo.Id
                               AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                               AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId =  Movement_Promo.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId =  Movement_Promo.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                               
        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId =  Movement_Promo.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId =  Movement_Promo.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                               
        LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                ON MovementFloat_CostPromo.MovementId =  Movement_Promo.Id
                               AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()
        
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId =  Movement_Promo.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementString AS MovementString_CommentMain
                                 ON MovementString_CommentMain.MovementId =  Movement_Promo.Id
                                AND MovementString_CommentMain.DescId = zc_MovementString_CommentMain()
                               
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
                         
    WHERE Movement_Promo.DescId = zc_Movement_Promo()
      AND Movement_Promo.ParentId is null;

ALTER TABLE Movement_Promo_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 31.10.15                                                         * 
*/

-- ����
-- SELECT * FROM Movement_Promo_View  where id = 805
