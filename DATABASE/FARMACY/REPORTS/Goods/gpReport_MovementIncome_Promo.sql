-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_MovementIncome_Promo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementIncome_Promo(
    IN inMakerId       Integer     -- �������������
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer      --�� ���������
              ,ItemName TVarChar       --��������(���) ���������
              ,StatusName TVarChar     --��������� ���������
              ,Amount TFloat           --���-�� ������ � ���������
              ,Code Integer            --��� ������
              ,Name TVarChar           --������������ ������
              ,PartnerGoodsName TVarChar  --������������ ����������
              ,MakerName  TVarChar     --�������������
              ,NDSKindName TVarChar    --��� ���
              ,OperDate TDateTime      --���� ���������
              ,InvNumber TVarChar      --� ���������
              ,UnitName TVarChar       --�������������
              ,MainJuridicalName TVarChar  --���� ��. ����
              ,JuridicalName TVarChar  --��. ����
              ,RetailName TVarChar     --�������� ����
              ,Price TFloat            --���� � ���������
              ,PriceWithVAT TFloat     --���� ������� � ��� 
              ,PriceSale TFloat        --���� �������
              ,PartionGoods TVarChar   --� ����� ���������
              ,ExpirationDate TDateTime--���� ��������
              ,PaymentDate TDateTime   --���� ������
              ,InvNumberBranch TVarChar--� ��������� � ������
              ,BranchDate TDateTime    --���� ��������� � ������
              ,InsertDate TDateTime    --���� (����.)
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpGetUserBySession (inSession);

    inEndDate := inEndDate+interval '1 day';

    RETURN QUERY
    WITH 
             -- Id ����� ������������� ���������� inMakerId
             tmpMIPromo AS (SELECT DISTINCT MI_Goods.Id AS MI_Id
                                 , MI_Goods.ObjectId AS GoodsId
                                 , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                 , MovementDate_EndPromo.ValueData    AS EndDate_Promo 
                            FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                            ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                           AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                           AND MovementLinkObject_Maker.ObjectId = inMakerId 

                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                              INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                                 AND MI_Goods.isErased = FALSE
                            WHERE Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.DescId = zc_Movement_Promo()
                             )

     -- �������� ��� ������ ���������� ������� � ������. ��������
    , tmpMovMIComplete AS (SELECT Movement.Id                     AS MovementId
                                , MovementDesc.ItemName        :: TVarChar AS ItemName
                                , Status.ValueData                         AS STatusName
                                , Movement.OperDate                        AS OperDate
                                , Movement.InvNumber                       AS InvNumber
                                , MIContainer.MovementItemId AS MovementItemId
                                , MIContainer.ObjectId_analyzer   AS GoodsId
                                , MIFloat_Price.ValueData                 ::TFloat  AS Price  
                                , COALESCE (MIFloat_PriceSale.ValueData,0)::TFloat  AS PriceSale
                                , COALESCE (MIFloat_AmountManual.ValueData,MIContainer.Amount)  AS Amount
                           FROM Movement 
                              INNER JOIN Object AS Status ON Status.Id = Movement.StatusId 
                              LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                              INNER JOIN MovementItemContainer AS MIContainer 
                                                               ON MIContainer.MovementId = Movement.Id
                                                              AND MIContainer.DescId = zc_MIContainer_Count()
                                                              AND MIContainer.MovementDescId = zc_Movement_Income()
                                                              AND COALESCE (MIContainer.ObjectIntId_analyzer,0) <> 0

                              INNER JOIN tmpMIPromo ON tmpMIPromo.MI_Id = MIContainer.ObjectIntId_analyzer
                              
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                          ON MIFloat_AmountManual.MovementItemId = MIContainer.MovementItemId
                                                         AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                  
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

                              LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                          ON MIFloat_PriceSale.MovementItemId = MIContainer.MovementItemId
                                                         AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                           WHERE Movement.DescId = zc_Movement_Income()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate 
                             AND COALESCE (inMakerId,0) <> 0
                         )
         , tmpMovMI_UnComplete AS (SELECT Movement.Id                      AS MovementId
                                        , MovementDesc.ItemName        :: TVarChar AS ItemName
                                        , Status.ValueData                         AS STatusName
                                        , Movement.OperDate                        AS OperDate
                                        , Movement.InvNumber                       AS InvNumber
                                        , MovementItem.Id                          AS MovementItemId
                                        , MovementItem.ObjectId                    AS GoodsId
                                        , MIFloat_Price.ValueData                 ::TFloat  AS Price  
                                        , COALESCE (MIFloat_PriceSale.ValueData,0)::TFloat  AS PriceSale
                                        , COALESCE (MIFloat_AmountManual.ValueData,MovementItem.Amount)  AS Amount
                                   FROM Movement 
                                      INNER JOIN Object AS Status ON Status.Id = Movement.StatusId 
                                      LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                                      LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                     
                                      INNER JOIN tmpMIPromo ON tmpMIPromo.GoodsId = MovementItem.ObjectId
                                                           AND Movement.OperDate >= StartDate_Promo
                                                           AND Movement.OperDate <= EndDate_Promo
                                      
                                      LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                                  ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                          
                                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                      LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                  ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                                   WHERE Movement.DescId = zc_Movement_Income()
                                     AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                     AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate 
                                 -- AND MIContainer.OperDate >= '01.11.2016' AND MIContainer.OperDate < '01.12.2016'
                                     AND COALESCE (inMakerId,0) <> 0
                                              )
          --
      , tmpMovMI AS (SELECT tmpMovMIComplete.MovementId
                            , tmpMovMIComplete.ItemName
                            , tmpMovMIComplete.STatusName
                            , tmpMovMIComplete.OperDate
                            , tmpMovMIComplete.InvNumber
                            , tmpMovMIComplete.MovementItemId
                            , tmpMovMIComplete.GoodsId
                            , tmpMovMIComplete.Price  
                            , tmpMovMIComplete.PriceSale
                            , tmpMovMIComplete.Amount
                       FROM tmpMovMIComplete
                     UNION 
                       SELECT tmpMovMI_UnComplete.MovementId
                            , tmpMovMI_UnComplete.ItemName
                            , tmpMovMI_UnComplete.STatusName
                            , tmpMovMI_UnComplete.OperDate
                            , tmpMovMI_UnComplete.InvNumber
                            , tmpMovMI_UnComplete.MovementItemId
                            , tmpMovMI_UnComplete.GoodsId
                            , tmpMovMI_UnComplete.Price  
                            , tmpMovMI_UnComplete.PriceSale
                            , tmpMovMI_UnComplete.Amount
                       FROM tmpMovMI_UnComplete
                    )
   -- �������� �������� ����������
   , tmpMov AS (SELECT  tmpMovMI.MovementId           
                      , Object_Unit.ValueData                    AS UnitName
                      , Object_MainJuridical.ValueData           AS MainJuridicalName
                      , Object_From.ValueData                    AS JuridicalName
                      , Object_Retail.ValueData                  AS RetailName 
                      , MovementDate_Payment.ValueData           AS PaymentDate
                      , MovementString_InvNumberBranch.ValueData AS InvNumberBranch
                      , MovementDate_Branch.ValueData            AS BranchDate
                      , MovementDate_Insert.ValueData            AS InsertDate
                      , COALESCE(MovementBoolean_PriceWithVAT.ValueData,False)  AS PriceWithVAT
                      , ObjectFloat_NDSKind_NDS.ValueData AS NDS
            
                FROM (SELECT DISTINCT tmpMovMI.MovementId
                      FROM tmpMovMI
                      ) AS tmpMovMI 
                        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = tmpMovMI.MovementId
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                        LEFT JOIN MovementDate AS MovementDate_Payment
                               ON MovementDate_Payment.MovementId = tmpMovMI.MovementId
                              AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                        LEFT JOIN MovementDate AS MovementDate_Branch
                               ON MovementDate_Branch.MovementId = tmpMovMI.MovementId
                              AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
        
                        LEFT JOIN MovementString AS MovementString_InvNumberBranch
                               ON MovementString_InvNumberBranch.MovementId = tmpMovMI.MovementId
                              AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
                        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                               ON MovementBoolean_PriceWithVAT.MovementId = tmpMovMI.MovementId
                              AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                               ON MovementLinkObject_NDSKind.MovementId = tmpMovMI.MovementId
                              AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                               ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                              AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                               ON MovementLinkObject_From.MovementId = tmpMovMI.MovementId
                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                               ON MovementLinkObject_Unit.MovementId = tmpMovMI.MovementId
                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                               ON MovementLinkObject_To.MovementId = tmpMovMI.MovementId
                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId   
                        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MovementLinkObject_Unit.ObjectId, MovementLinkObject_To.ObjectId) 

                        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                               ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Object_MainJuridical.Id
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                )

      -- ���������
      SELECT  tmpMovMI.MovementId                      AS MovementId
            , tmpMovMI.ItemName        :: TVarChar
            , tmpMovMI.STatusName
            , tmpMovMI.Amount
            , Object.ObjectCode                        AS Code
            , Object.ValueData                         AS Name
            , Object_PartnerGoods.ValueData            AS PartnerGoodsName
            , ObjectString_Goods_Maker.ValueData       AS MakerName
            , Object_NDSKind.ValueData                 AS NDSKindName
            , tmpMovMI.OperDate                        AS OperDate
            , tmpMovMI.InvNumber                       AS InvNumber
            , tmpMov.UnitName
            , tmpMov.MainJuridicalName
            , tmpMov.JuridicalName
            , tmpMov.RetailName 
            , tmpMovMI.Price
            , CASE WHEN COALESCE(tmpMov.PriceWithVAT,False) = TRUE THEN tmpMovMI.Price
                   ELSE (tmpMovMI.Price * (1 + tmpMov.NDS /100))::TFloat
              END AS PriceWithVAT

            , tmpMovMI.PriceSale  
            
            , COALESCE (MIString_PartionGoods.ValueData, '')             :: TVarChar  AS PartionGoods
            , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) :: TDateTime AS ExpirationDate
         
            , tmpMov.PaymentDate
            , tmpMov.InvNumberBranch
            , tmpMov.BranchDate
            , tmpMov.InsertDate
            
      FROM tmpMovMI 
       
        LEFT JOIN tmpMov ON tmpMov.MovementId = tmpMovMI.MovementId

        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                         ON MILinkObject_Goods.MovementItemId = tmpMovMI.MovementItemId
                                        AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

        LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                               ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                              AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() 

        LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId

        LEFT JOIN Object ON Object.Id = tmpMovMI.GoodsId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                    ON MIDate_ExpirationDate.MovementItemId = tmpMovMI.MovementItemId
                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()                                         

        LEFT JOIN MovementItemString AS MIString_PartionGoods
                                     ON MIString_PartionGoods.MovementItemId = tmpMovMI.MovementItemId
                                    AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()                                         
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 07.11.16         *
*/

-- ����
-- SELECT * FROM gpReport_MovementIncome_Promo (inMakerId:= 2336655, inStartDate:= '21.11.2016', inEndDate:= '25.11.2016', inSession:= '2')
--SELECT * FROM gpReport_MovementIncome_Promo (inMakerId:= 2336655, inStartDate:= '01.12.2016', inEndDate:= '03.12.2016', inSession:= '2')