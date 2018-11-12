-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_MovementIncome_Promo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementIncome_Promo(
    IN inMakerId       Integer     -- �������������
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer      --�� ���������
             , ItemName TVarChar       --��������(���) ���������
             , StatusName TVarChar     --��������� ���������
             , Amount TFloat           --���-�� ������ � ���������
             , Code Integer            --��� ������
             , Name TVarChar           --������������ ������
             , PartnerGoodsName TVarChar  --������������ ����������
             , MakerName  TVarChar     --�������������
             , NDSKindName TVarChar    --��� ���
             , NDS         TFloat      -- % ���
             , OperDate TDateTime      --���� ���������
             , InvNumber TVarChar      --� ���������
             , UnitName TVarChar       --�������������
             , MainJuridicalName TVarChar  --���� ��. ����
             , JuridicalName TVarChar  --��. ����
             , RetailName TVarChar     --�������� ����
             , Price TFloat            --���� � ���������
             , PriceWithVAT TFloat     --���� ������� � ��� 
             , PriceSale TFloat        --���� �������
             , PartionGoods TVarChar   --� ����� ���������
             , ExpirationDate TDateTime--���� ��������
             , PaymentDate TDateTime   --���� ������
             , InvNumberBranch TVarChar--� ��������� � ������
             , BranchDate TDateTime    --���� ��������� � ������
             , InsertDate TDateTime    --���� (����.)
             , isChecked  Boolean      -- ��� ����������
             , isReport   Boolean      -- ��� ������
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
    tmpMIPromo AS (SELECT DISTINCT MI_Goods.Id               AS MI_Id
                        , MI_Goods.ObjectId                  AS GoodsId
                        , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                        , MovementDate_EndPromo.ValueData    AS EndDate_Promo
                        , COALESCE (MIBoolean_Checked.ValueData, FALSE)                                           ::Boolean  AS isChecked
                        , CASE WHEN COALESCE (MIBoolean_Checked.ValueData, FALSE) = TRUE THEN FALSE ELSE TRUE END ::Boolean  AS isReport
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
                     LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                   ON MIBoolean_Checked.MovementItemId = MI_Goods.Id
                                                  AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                   WHERE Movement.StatusId = zc_Enum_Status_Complete()
                     AND Movement.DescId = zc_Movement_Promo()
                    )

   -- �������� ��� ������ ���������� ������� � ������. ��������
  , tmpMovMIComplete_All AS (SELECT Movement.Id                       AS MovementId
                                  , Movement.DescId                   AS DescId
                                  , Movement.StatusId                 AS StatusId 
                                  , Movement.OperDate                 AS OperDate
                                  , Movement.InvNumber                AS InvNumber
                                  , MIContainer.MovementItemId        AS MovementItemId
                                  , MIContainer.ObjectId_analyzer     AS GoodsId
                                  , COALESCE (MIContainer.Amount, 0)  AS Amount
                                  , tmpMIPromo.isChecked
                                  , tmpMIPromo.isReport
                             FROM Movement 
                                INNER JOIN MovementItemContainer AS MIContainer 
                                                                 ON MIContainer.MovementId = Movement.Id
                                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                                                AND MIContainer.MovementDescId = zc_Movement_Income()
                                                                AND COALESCE (MIContainer.ObjectIntId_analyzer,0) <> 0
    
                                INNER JOIN tmpMIPromo ON tmpMIPromo.MI_Id = MIContainer.ObjectIntId_analyzer
                               
                             WHERE Movement.DescId = zc_Movement_Income()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate 
                             --AND Movement.OperDate >= '01.01.2018'/*inStartDate*/ AND Movement.OperDate < '20.02.2018' /*inEndDate */
                               AND COALESCE (inMakerId,0) <> 0
                           )

  , tmpMovMI_UnComplete_All AS (SELECT Movement.Id                     AS MovementId
                                     , Movement.DescId                 AS DescId
                                     , Movement.StatusId               AS StatusId 
                                     , Movement.OperDate               AS OperDate
                                     , Movement.InvNumber              AS InvNumber
                                     , MovementItem.Id                 AS MovementItemId
                                     , MovementItem.ObjectId           AS GoodsId
                                     , COALESCE (MovementItem.Amount)  AS Amount
                                     , tmpMIPromo.isChecked
                                     , tmpMIPromo.isReport
                                FROM Movement 
                                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                  
                                   INNER JOIN tmpMIPromo ON tmpMIPromo.GoodsId = MovementItem.ObjectId
                                                        AND Movement.OperDate >= StartDate_Promo
                                                        AND Movement.OperDate <= EndDate_Promo
                                WHERE Movement.DescId = zc_Movement_Income()
                                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                  AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate 
                                --AND Movement.OperDate >= '01.01.2018'/*inStartDate*/ AND Movement.OperDate < '20.02.2018' /*inEndDate */
                                  AND COALESCE (inMakerId,0) <> 0
                                           )
          --
  , tmpMI_Float AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovMIComplete_All.MovementItemId FROM tmpMovMIComplete_All 
                                                              UNION
                                                              SELECT DISTINCT tmpMovMI_UnComplete_All.MovementItemId FROM tmpMovMI_UnComplete_All)
                   )
  , tmpMovMIComplete AS (SELECT Movement.MovementId 
                                , Movement.DescId
                                , Movement.StatusId
                                , Movement.OperDate
                                , Movement.InvNumber
                                , Movement.MovementItemId
                                , Movement.GoodsId
                                , MIFloat_Price.ValueData                 ::TFloat    AS Price  
                                , COALESCE (MIFloat_PriceSale.ValueData,0)::TFloat    AS PriceSale
                                , COALESCE (MIFloat_AmountManual.ValueData, Movement.Amount)  AS Amount
                                , Movement.isChecked
                                , Movement.isReport
                           FROM tmpMovMIComplete_All AS Movement 
                              LEFT JOIN tmpMI_Float AS MIFloat_AmountManual
                                                    ON MIFloat_AmountManual.MovementItemId = Movement.MovementItemId
                                                   AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                  
                              LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

                              LEFT JOIN tmpMI_Float AS MIFloat_PriceSale
                                                    ON MIFloat_PriceSale.MovementItemId = Movement.MovementItemId
                                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                         )

  , tmpMovMI_UnComplete AS (SELECT Movement.MovementId 
                                 , Movement.DescId
                                 , Movement.StatusId
                                 , Movement.OperDate
                                 , Movement.InvNumber
                                 , Movement.MovementItemId
                                 , Movement.GoodsId
                                 , MIFloat_Price.ValueData                 ::TFloat  AS Price  
                                 , COALESCE (MIFloat_PriceSale.ValueData,0)::TFloat  AS PriceSale
                                 , COALESCE (MIFloat_AmountManual.ValueData, Movement.Amount)  AS Amount
                                 , Movement.isChecked
                                 , Movement.isReport
                            FROM tmpMovMI_UnComplete_All AS Movement 
                               LEFT JOIN tmpMI_Float AS MIFloat_AmountManual
                                                     ON MIFloat_AmountManual.MovementItemId = Movement.MovementItemId
                                                    AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                   
                               LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()

                               LEFT JOIN tmpMI_Float AS MIFloat_PriceSale
                                                           ON MIFloat_PriceSale.MovementItemId = Movement.MovementItemId
                                                          AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                            )

  , tmpMovMI AS (SELECT tmpMovMIComplete.MovementId
                      , tmpMovMIComplete.DescId
                      , tmpMovMIComplete.StatusId
                      , tmpMovMIComplete.OperDate
                      , tmpMovMIComplete.InvNumber
                      , tmpMovMIComplete.MovementItemId
                      , tmpMovMIComplete.GoodsId
                      , tmpMovMIComplete.Price  
                      , tmpMovMIComplete.PriceSale
                      , tmpMovMIComplete.Amount
                      , tmpMovMIComplete.isChecked
                      , tmpMovMIComplete.isReport
                 FROM tmpMovMIComplete
               UNION 
                 SELECT tmpMovMI_UnComplete.MovementId
                      , tmpMovMI_UnComplete.DescId
                      , tmpMovMI_UnComplete.StatusId
                      , tmpMovMI_UnComplete.OperDate
                      , tmpMovMI_UnComplete.InvNumber
                      , tmpMovMI_UnComplete.MovementItemId
                      , tmpMovMI_UnComplete.GoodsId
                      , tmpMovMI_UnComplete.Price  
                      , tmpMovMI_UnComplete.PriceSale
                      , tmpMovMI_UnComplete.Amount
                      , tmpMovMI_UnComplete.isChecked
                      , tmpMovMI_UnComplete.isReport
                 FROM tmpMovMI_UnComplete
              )

  , tmpMovementDate AS (SELECT MovementDate.*
                        FROM MovementDate
                        WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovMI.MovementId FROM tmpMovMI)
                       )
  , tmpMovementString AS (SELECT MovementString.*
                        FROM MovementString
                        WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovMI.MovementId FROM tmpMovMI)
                       )
  , tmpMovementBoolean AS (SELECT MovementBoolean.*
                        FROM MovementBoolean
                        WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovMI.MovementId FROM tmpMovMI)
                       )
  , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                        FROM MovementLinkObject
                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovMI.MovementId FROM tmpMovMI)
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
           
                     , MovementDesc.ItemName        :: TVarChar AS ItemName
                     , Status.ValueData                         AS STatusName
               FROM (SELECT DISTINCT tmpMovMI.MovementId, tmpMovMI.StatusId, tmpMovMI.DescId
                     FROM tmpMovMI
                     ) AS tmpMovMI 
                       LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                                 ON MovementDate_Insert.MovementId = tmpMovMI.MovementId
                                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                       LEFT JOIN tmpMovementDate AS MovementDate_Payment
                                                 ON MovementDate_Payment.MovementId = tmpMovMI.MovementId
                                                AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                       LEFT JOIN tmpMovementDate AS MovementDate_Branch
                                                 ON MovementDate_Branch.MovementId = tmpMovMI.MovementId
                                                AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
       
                       LEFT JOIN tmpMovementString AS MovementString_InvNumberBranch
                                                   ON MovementString_InvNumberBranch.MovementId = tmpMovMI.MovementId
                                                  AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
                       LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                                    ON MovementBoolean_PriceWithVAT.MovementId = tmpMovMI.MovementId
                                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_NDSKind
                                                       ON MovementLinkObject_NDSKind.MovementId = tmpMovMI.MovementId
                                                      AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                       LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                             ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                            AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = tmpMovMI.MovementId
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = tmpMovMI.MovementId
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
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

                       LEFT JOIN Object AS Status ON Status.Id = tmpMovMI.StatusId 
                       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMovMI.DescId
               )



  , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                       , ObjectString_Goods_Maker.ValueData       AS MakerName
                                  FROM MovementItemLinkObject
                                       LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                           ON ObjectString_Goods_Maker.ObjectId = MovementItemLinkObject.ObjectId
                                          AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() and 1=0
                                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovMI.MovementItemId FROM tmpMovMI)
                                    AND MovementItemLinkObject.DescId = zc_MILinkObject_Goods()
             
                                 )

  , tmpMovementItemDate AS (SELECT MovementItemDate.*
                            FROM MovementItemDate
                            WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMovMI.MovementItemId FROM tmpMovMI)
                              AND MovementItemDate.DescId = zc_MIDate_PartionGoods() 
                           )
  , tmpMovementItemString AS (SELECT MovementItemString.*
                              FROM MovementItemString
                              WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMovMI.MovementItemId FROM tmpMovMI)
                                AND MovementItemString.DescId = zc_MIString_PartionGoods()
                             )
  , tmpNDSKind AS (SELECT ObjectLink.*
                   FROM ObjectLink
                   WHERE ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind()
                     AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpMovMI.GoodsId FROM tmpMovMI)
                  )
  , tmpGoods AS (SELECT tmp.GoodsId
                      , Object.ObjectCode                        AS Code
                      , Object.ValueData                         AS Name
                      , Object_NDSKind.ValueData                 AS NDSKindName
                      , ObjectFloat_NDSKind_NDS.ValueData        AS NDS
                 FROM (SELECT DISTINCT tmpMovMI.GoodsId FROM tmpMovMI) AS tmp
                      LEFT JOIN Object ON Object.Id = tmp.GoodsId
  
                      LEFT JOIN tmpNDSKind AS ObjectLink_Goods_NDSKind
                                           ON ObjectLink_Goods_NDSKind.ObjectId = Object.Id
                                          
                      LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
              
                      LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                            ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                           AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                 )

      -- ���������
      SELECT  tmpMovMI.MovementId
            , tmpMov.ItemName        :: TVarChar
            , tmpMov.STatusName
            , tmpMovMI.Amount        :: Tfloat
            , tmpGoods.Code
            , tmpGoods.Name
            , Object_PartnerGoods.ValueData      AS PartnerGoodsName
            , MILinkObject_Goods.MakerName
            , tmpGoods.NDSKindName
            , tmpGoods.NDS

            , tmpMovMI.OperDate
            , tmpMovMI.InvNumber
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
            
            , tmpMovMI.isChecked
            , tmpMovMI.isReport
            
      FROM tmpMovMI 
           LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpMovMI.GoodsId
    
           LEFT JOIN tmpMov ON tmpMov.MovementId = tmpMovMI.MovementId
   
           LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = tmpMovMI.MovementItemId
           LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId  

           LEFT JOIN tmpMovementItemDate AS MIDate_ExpirationDate
                                         ON MIDate_ExpirationDate.MovementItemId = tmpMovMI.MovementItemId
     
           LEFT JOIN tmpMovementItemString AS MIString_PartionGoods
                                           ON MIString_PartionGoods.MovementItemId = tmpMovMI.MovementItemId
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 20.02.18         *
 07.11.16         *
*/

-- ����
-- SELECT * FROM gpReport_MovementIncome_Promo_22 (inMakerId:= 2336655, inStartDate:= '21.11.2016', inEndDate:= '25.11.2016', inSession:= '2')
--SELECT * FROM gpReport_MovementIncome_Promo_22 (inMakerId:= 2336655, inStartDate:= '01.12.2016', inEndDate:= '03.12.2016', inSession:= '2')
--select * from gpReport_MovementIncome_Promo(inMakerId := 2336599 , inStartDate := ('01.01.2018')::TDateTime , inEndDate := ('01.03.2018')::TDateTime ,  inSession := '3'::TVarChar);