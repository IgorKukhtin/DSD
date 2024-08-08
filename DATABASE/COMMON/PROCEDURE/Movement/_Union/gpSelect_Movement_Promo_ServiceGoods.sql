-- Function: gpSelect_Movement_Promo_ServiceGoods()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_ServiceGoods (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_ServiceGoods(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inIsErased                 Boolean ,
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS TABLE (Id               Integer     --�������������
             , InvNumber        Integer     --����� ��������� 
             , InvNumber_full   TVarChar    --
             , OperDate         TDateTime   --���� ���������
             , StatusCode       Integer     --��� �������
             , StatusName       TVarChar    --������
             , DescName         TVarChar    --��� ���������
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
             , UnitId           Integer     --�������������
             , UnitName         TVarChar    --�������������
             , PersonalTradeId  Integer     --������������� ������������� ������������� ������
             , PersonalTradeName TVarChar   --������������� ������������� ������������� ������
             , PersonalId       Integer     --������������� ������������� �������������� ������
             , PersonalName     TVarChar    --������������� ������������� �������������� ������
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!�������� ������!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- ���������
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

         , tmpMovement AS (SELECT Movement.*
                           FROM tmpStatus
                                INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                                   AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND Movement.DescId IN (zc_Movement_Promo())
                          )


        -- ���������
        SELECT Movement.Id                                                 --�������������
             , Movement.InvNumber :: Integer                               --����� ���������  
             , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) :: TVarChar AS InvNumber_full
             , Movement.OperDate                                           --���� ���������
             , Object_Status.ObjectCode        :: Integer  AS StatusCode
             , Object_Status.ValueData         :: TVarChar AS StatusName 
             , MovementDesc.ItemName           ::TVarChar  AS DescName
             , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --��� �����
             , Object_PromoKind.ValueData                  AS PromoKindName      --��� �����
             , Object_PromoStateKind.Id                    AS PromoStateKindId        --��������� �����
             , Object_PromoStateKind.ValueData             AS PromoStateKindName      --��������� �����
             , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --����� ����
             , Object_PriceList.ValueData                  AS PriceListName      --����� ����
             , MovementDate_StartPromo.ValueData           AS StartPromo         --���� ������ �����
             , MovementDate_EndPromo.ValueData             AS EndPromo           --���� ��������� �����    
             , MovementDate_StartSale.ValueData            AS StartSale          --���� ������ �������� �� ��������� ����
             , MovementDate_EndSale.ValueData              AS EndSale            --���� ��������� �������� �� ��������� ����
             , MovementDate_EndReturn.ValueData            AS EndReturn          --���� ��������� ��������� �� ��������� ����
             , MovementDate_OperDateStart.ValueData        AS OperDateStart      --���� ������ ����. ������ �� �����
             , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --���� ��������� ����. ������ �� �����
             , MovementDate_Month.ValueData                AS MonthPromo         -- ����� �����
             , MovementLinkObject_Unit.ObjectId            AS UnitId             --�������������
             , Object_Unit.ValueData                       AS UnitName           --�������������
             , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --������������� ������������� ������������� ������
             , Object_PersonalTrade.ValueData              AS PersonalTradeName  --������������� ������������� ������������� ������
             , MovementLinkObject_Personal.ObjectId        AS PersonalId         --������������� ������������� �������������� ������
             , Object_Personal.ValueData                   AS PersonalName       --������������� ������������� �������������� ������

        FROM tmpMovement AS Movement
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoKind
                                          ON MovementLinkObject_PromoKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
             LEFT JOIN Object AS Object_PromoKind
                              ON Object_PromoKind.Id = MovementLinkObject_PromoKind.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                          ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
             LEFT JOIN Object AS Object_PriceList
                              ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

             LEFT JOIN MovementDate AS MovementDate_StartSale
                                    ON MovementDate_StartSale.MovementId = Movement.Id
                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
             LEFT JOIN MovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.MovementId = Movement.Id
                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                    ON MovementDate_StartPromo.MovementId = Movement.Id
                                   AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                    ON MovementDate_EndPromo.MovementId =  Movement.Id
                                   AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

             LEFT JOIN MovementDate AS MovementDate_EndReturn
                                    ON MovementDate_EndReturn.MovementId = Movement.Id
                                   AND MovementDate_EndReturn.DescId = zc_MovementDate_EndReturn()

             LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId = Movement.Id
                                   AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
             LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                   AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

             LEFT JOIN MovementDate AS MovementDate_Month
                                    ON MovementDate_Month.MovementId = Movement.Id
                                   AND MovementDate_Month.DescId = zc_MovementDate_Month()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_Unit
                              ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
             LEFT JOIN Object AS Object_PersonalTrade
                              ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                          ON MovementLinkObject_Personal.MovementId = Movement.Id
                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
             LEFT JOIN Object AS Object_Personal
                              ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                          ON MovementLinkObject_PromoStateKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PromoStateKind.DescId = zc_MovementLinkObject_PromoStateKind()
             LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementLinkObject_PromoStateKind.ObjectId
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.08.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Promo_ServiceGoods (inStartDate:= '01.01.2024', inEndDate:= '01.01.2024', inIsErased := FALSE, inSession:= '2')