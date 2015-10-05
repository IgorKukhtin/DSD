-- Function: gpReport_OrderExternal()

DROP FUNCTION IF EXISTS gpReport_OrderExternal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inFromId             Integer   , -- �� ���� (� ���������)
    IN inToId               Integer   , -- ���� (� ���������)
    IN inRouteId            Integer   , -- �������
    IN inRouteSortingId     Integer   , -- ���������� ���������
    IN inGoodsGroupId       Integer   ,
    IN inIsByDoc            Boolean   ,
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (InvNumber TVarChar
             , InvNumberPartner TVarChar
             , ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , FromCode Integer, FromName TVarChar
             , ToCode Integer, ToName TVarChar
             , RouteGroupName TVarChar, RouteName TVarChar
             , RouteSortingName TVarChar
             , PersonalName TVarChar
             , PaidKindName TVarChar

             , JuridicalName TVarChar
             , RetailName TVarChar
             , PartnerTagName TVarChar
             , RegionName TVarChar
             , CityKindName TVarChar
             , CityName TVarChar
             , StreetKindName TVarChar
             , StreetName TVarChar

             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar, TradeMarkName TVarChar

             , AmountSumm1 TFloat, AmountSumm2 TFloat
             , AmountSumm_Dozakaz1 TFloat, AmountSumm_Dozakaz2 TFloat
             , AmountSumm TFloat

             , Amount_Weight1 TFloat, Amount_Sh1 TFloat
             , Amount_Weight2 TFloat, Amount_Sh2 TFloat
             , Amount_Weight_Dozakaz1 TFloat, Amount_Sh_Dozakaz1 TFloat
             , Amount_Weight_Dozakaz2 TFloat, Amount_Sh_Dozakaz2 TFloat
             , Amount TFloat, Amount_Weight TFloat, Amount_Sh TFloat

             , Amount_WeightSK TFloat
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyCode_goods Integer, InfoMoneyName_goods TVarChar, InfoMoneyName_goods_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- ����������� �� �������
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;


    --
    inIsByDoc:= (inStartDate = inEndDate);


     RETURN QUERY
     WITH tmpPartnerAddress AS (SELECT * FROM Object_Partner_Address_View)
     , tmpMovement2 AS (
       SELECT
             CASE WHEN inIsByDoc = TRUE THEN Movement.Id ELSE 0 END   AS MovementId
           , MovementLinkObject_Contract.ObjectId                     AS ContractId
           , MovementLinkObject_From.ObjectId                         AS FromId
           , MovementLinkObject_To.ObjectId                           AS ToId
           , MovementLinkObject_Route.ObjectId                        AS RouteId
           , MovementLinkObject_RouteSorting.ObjectId                 AS RouteSortingId
           , MovementLinkObject_Personal.ObjectId                     AS PersonalId
           , MovementLinkObject_PaidKind.ObjectId                     AS PaidKindId
           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) AS isPriceWithVAT
           , COALESCE (MovementFloat_VATPercent.ValueData, 0)         AS VATPercent
           , COALESCE (MovementFloat_ChangePercent.ValueData, 0)      AS ChangePercent
           , MovementItem.ObjectId                                    AS GoodsId
           , MILinkObject_GoodsKind.ObjectId                          AS GoodsKindId
           , ObjectLink_Goods_InfoMoney.ChildObjectId                 AS InfoMoneyId

           , SUM (CASE WHEN Movement.OperDate =  COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) THEN MovementItem.Amount ELSE 0 END) AS Amount1
           , SUM (CASE WHEN Movement.OperDate <> COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) THEN MovementItem.Amount ELSE 0 END) AS Amount2
           , SUM (CASE WHEN Movement.OperDate =  COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) THEN COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSecond1
           , SUM (CASE WHEN Movement.OperDate <> COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) THEN COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSecond2
           , CASE WHEN MIFloat_CountForPrice.ValueData > 0
                       THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                  ELSE COALESCE (MIFloat_Price.ValueData, 0)
             END
           * CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                       THEN (1 + MovementFloat_ChangePercent.ValueData / 100)
                  ELSE 1
             END
           * CASE WHEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) = TRUE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                         -- ���� ���� � ��� ��� %���=0
                         THEN 1
                    ELSE -- ���� ���� ��� ���
                         1 + MovementFloat_VATPercent.ValueData / 100
             END AS Price

       FROM Movement
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                        ON MovementLinkObject_Route.MovementId = Movement.Id
                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                       ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                      AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                        ON MovementLinkObject_Personal.MovementId = Movement.Id
                                       AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

           LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                           AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ��������� + ������ ������ �����
           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()


       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND Movement.StatusId = zc_Enum_Status_Complete()
         AND Movement.DescId = zc_Movement_OrderExternal()
         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) = CASE WHEN inRouteSortingId <> 0 THEN inRouteSortingId ELSE COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) END)
       GROUP BY
             CASE WHEN inIsByDoc = TRUE THEN Movement.Id ELSE 0 END
           , MovementLinkObject_Contract.ObjectId
           , MovementLinkObject_From.ObjectId
           , MovementLinkObject_To.ObjectId
           , MovementLinkObject_Route.ObjectId
           , MovementLinkObject_RouteSorting.ObjectId
           , MovementLinkObject_Personal.ObjectId
           , MovementLinkObject_PaidKind.ObjectId
           , MovementBoolean_PriceWithVAT.ValueData
           , MovementFloat_VATPercent.ValueData
           , MovementFloat_ChangePercent.ValueData
           , MovementItem.ObjectId
           , MILinkObject_GoodsKind.ObjectId
           , ObjectLink_Goods_InfoMoney.ChildObjectId
           , MIFloat_CountForPrice.ValueData
           , MIFloat_Price.ValueData
         )

     , tmpMovement AS (
       SELECT tmpMovement2.MovementId
            , tmpMovement2.FromId
            , tmpMovement2.ToId
            , tmpMovement2.ContractId
            , tmpMovement2.RouteId
            , tmpMovement2.RouteSortingId
            , tmpMovement2.PersonalId
            , tmpMovement2.PaidKindId
            , tmpMovement2.GoodsKindId
            , tmpMovement2.GoodsId
            , tmpMovement2.InfoMoneyId

           , SUM (Amount1 + Amount2 + AmountSecond1 + AmountSecond2) AS Amount
           , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount1 ELSE 0 END)                                 AS Amount_Sh1
           , SUM (Amount1 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS Amount_Weight1
           , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount2 ELSE 0 END)                                 AS Amount_Sh2
           , SUM (Amount2 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS Amount_Weight2

           , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN AmountSecond1 ELSE 0 END)                                 AS AmountSecond_Sh1
           , SUM (AmountSecond1 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS AmountSecond_Weight1
           , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN AmountSecond2 ELSE 0 END)                                 AS AmountSecond_Sh2
           , SUM (AmountSecond2 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS AmountSecond_Weight2

           , SUM (Amount1 * Price) AS Summ1
           , SUM (Amount2 * Price) AS Summ2
           , SUM (AmountSecond1 * Price) AS SummSecond1
           , SUM (AmountSecond2 * Price) AS SummSecond2

       FROM tmpMovement2
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMovement2.GoodsId
                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = tmpMovement2.GoodsId
                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
       GROUP BY tmpMovement2.MovementId
              , tmpMovement2.FromId
              , tmpMovement2.ToId
              , tmpMovement2.ContractId
              , tmpMovement2.RouteId
              , tmpMovement2.RouteSortingId
              , tmpMovement2.PersonalId
              , tmpMovement2.PaidKindId
              , tmpMovement2.GoodsKindId
              , tmpMovement2.GoodsId
              , tmpMovement2.InfoMoneyId
      )
       -- ���������
       SELECT
             Movement.InvNumber                         AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber          AS ContractNumber
           , View_Contract_InvNumber.ContractTagName
           , View_Contract_InvNumber.ContractTagGroupName

           , Object_From.ObjectCode                     AS FromCode
           , Object_From.ValueData                      AS FromName
           , Object_To.ObjectCode                       AS ToCode
           , Object_To.ValueData                        AS ToName

           , Object_RouteGroup.ValueData                AS RouteGroupName
           , Object_Route.ValueData                     AS RouteName
           , Object_RouteSorting.ValueData              AS RouteSortingName
           , Object_Personal.ValueData                  AS PersonalName
           , Object_PaidKind.ValueData                  AS PaidKindName

           , Object_Juridical.ValueData    AS JuridicalName
           , Object_Retail.ValueData       AS RetailName
           , View_Partner_Address.PartnerTagName
           , View_Partner_Address.RegionName
           , View_Partner_Address.CityKindName
           , View_Partner_Address.CityName
           , View_Partner_Address.StreetKindName
           , View_Partner_Address.StreetName

           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_TradeMark.ValueData                 AS TradeMarkName

           ,  tmpMovement.Summ1                            :: TFloat AS AmountSumm1
           ,  tmpMovement.Summ2                            :: TFloat AS AmountSumm2
           , (tmpMovement.SummSecond1)       :: TFloat AS AmountSumm_Dozakaz1
           , (tmpMovement.SummSecond2)       :: TFloat AS AmountSumm_Dozakaz2
           , (tmpMovement.Summ1 + tmpMovement.Summ2 + tmpMovement.SummSecond1 + tmpMovement.SummSecond2) :: TFloat AS AmountSumm

           , tmpMovement.Amount_Weight1        :: TFloat AS Amount_Weight1
           , tmpMovement.Amount_Sh1            :: TFloat AS Amount_Sh1
           , tmpMovement.Amount_Weight2        :: TFloat AS Amount_Weight2
           , tmpMovement.Amount_Sh2            :: TFloat AS Amount_Sh2
           , (tmpMovement.AmountSecond_Weight1) :: TFloat AS Amount_Weight_Dozakaz1
           , (tmpMovement.AmountSecond_Sh1 )    :: TFloat AS Amount_Sh_Dozakaz1
           , (tmpMovement.AmountSecond_Weight2) :: TFloat AS Amount_Weight_Dozakaz2
           , (tmpMovement.AmountSecond_Sh2)     :: TFloat AS Amount_Sh_Dozakaz2

           , (tmpMovement.Amount) :: TFloat AS Amount
           , (tmpMovement.Amount_Weight1 + tmpMovement.Amount_Weight2 + tmpMovement.AmountSecond_Weight1 + tmpMovement.AmountSecond_Weight2) :: TFloat AS Amount_Weight
           , (tmpMovement.Amount_Sh1 + tmpMovement.Amount_Sh2 + tmpMovement.AmountSecond_Sh1 + tmpMovement.AmountSecond_Sh2)         :: TFloat AS Amount_Sh

           , 0 :: TFloat AS Amount_WeightSK

           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all

           , View_InfoMoney_goods.InfoMoneyCode                   AS InfoMoneyCode_goods
           , View_InfoMoney_goods.InfoMoneyName                   AS InfoMoneyName_goods
           , View_InfoMoney_goods.InfoMoneyName_all               AS InfoMoneyName_goods_all

       FROM tmpMovement
          LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId
          LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = tmpMovement.RouteSortingId
          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpMovement.PersonalId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMovement.PaidKindId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovement.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovement.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                             AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
          LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = tmpMovement.FromId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
          LEFT JOIN tmpPartnerAddress AS View_Partner_Address ON View_Partner_Address.PartnerId = tmpMovement.FromId

          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpMovement.ContractId
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_goods ON View_InfoMoney_goods.InfoMoneyId = tmpMovement.InfoMoneyId
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_OrderExternal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.06.15                                        * ALL
 02.09.14                                                        *
 29.08.14                                                        *
 22.08.14                                                        *
 21.08.14                                                        *
*/

-- ����
-- SELECT * FROM gpReport_OrderExternal (inStartDate:= '01.10.2015', inEndDate:= '01.10.2015', inFromId := 0, inToId := 0, inRouteId := 0, inRouteSortingId := 0, inGoodsGroupId := 0, inIsByDoc := False, inSession:= zfCalc_UserAdmin())
