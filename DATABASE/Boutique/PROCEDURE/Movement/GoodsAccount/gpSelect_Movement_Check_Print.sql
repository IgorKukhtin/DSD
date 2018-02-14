-- Function: gpSelect_Movement_Check_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_Print(
    IN inMovementId        Integer  ,  -- ���� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE vbUnitId Integer;
    DECLARE vbClientId Integer;
    DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale_Print());
     vbUserId:= inSession;

     -- ��������� �� ���������
     SELECT CASE WHEN Object_From.DescId = zc_Object_Client() THEN MovementLinkObject_From.ObjectId ELSE MovementLinkObject_To.ObjectId   END AS ClientId
          , CASE WHEN Object_To.DescId   = zc_Object_Unit()   THEN MovementLinkObject_To.ObjectId   ELSE MovementLinkObject_From.ObjectId END AS UnitId
          , Movement.StatusId                AS StatusId
            INTO vbClientId, vbUnitId, vbStatusId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
     WHERE Movement.Id = inMovementId;

      --
    OPEN Cursor1 FOR
     WITH 
     tmpDiscountTools AS (SELECT OS_DiscountTools_StartSumm.ValueData   AS StartSumm
                               , OS_DiscountTools_EndSumm.ValueData     AS EndSumm
                               , OS_DiscountTools_DiscountTax.ValueData AS DiscountTax
                          FROM Object
                               LEFT JOIN ObjectFloat AS OS_DiscountTools_StartSumm
                                                     ON OS_DiscountTools_StartSumm.ObjectId = Object.Id
                                                    AND OS_DiscountTools_StartSumm.DescId = zc_ObjectFloat_DiscountTools_StartSumm()
                               LEFT JOIN ObjectFloat AS OS_DiscountTools_EndSumm
                                                     ON OS_DiscountTools_EndSumm.ObjectId = Object.Id
                                                    AND OS_DiscountTools_EndSumm.DescId = zc_ObjectFloat_DiscountTools_EndSumm()
                               LEFT JOIN ObjectFloat AS OS_DiscountTools_DiscountTax
                                                     ON OS_DiscountTools_DiscountTax.ObjectId = Object.Id
                                                    AND OS_DiscountTools_DiscountTax.DescId = zc_ObjectFloat_DiscountTools_DiscountTax()
                          WHERE Object.DescId = zc_Object_DiscountTools()
                            AND Object.isErased = FALSE
                          )
   , tmpDiscount AS (SELECT t1.DiscountTax
                          , t1.StartSumm
                          , t1.EndSumm
                          , t2.DiscountTax AS DiscountTax_Next
                          , t2.StartSumm   AS StartSumm_Next
                          , t2.EndSumm     AS EndSumm_Next
                     from tmpDiscountTools as t1
                          LEFT JOIN tmpDiscountTools AS t2 ON t2.StartSumm= t1.EndSumm
                     )
--
   -- ������� ��� ���������� �� ���������� � ������������� , ���� ������� 
   , tmpContainer AS (SELECT CLO_PartionMI.ObjectId          AS PartionId_MI
                           , Container.Amount
                      FROM Container
                           INNER JOIN ContainerLinkObject AS CLO_Client 
                                                          ON CLO_Client.ContainerId = Container.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                         AND CLO_Client.ObjectId    = vbClientId                            --inClientId --������� ������� 6343  -- 
                           INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                          ON CLO_Unit.ContainerId = Container.Id
                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                         AND CLO_Unit.ObjectId    = vbUnitId
                           LEFT JOIN ContainerLinkObject AS CLO_PartionMI 
                                                         ON CLO_PartionMI.ContainerId = Container.Id
                                                        AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                       -- !!!����� ���������� + ������� ������� ��������!!!
                       WHERE Container.ObjectId <> zc_Enum_Account_20102() 
                         AND Container.DescId  = zc_Container_Summ()                         
                     ) 
   -- �������� �������� ���� � � ��� ��� ������ �������
   , tmpPartion AS (SELECT tmpContainer.PartionId_MI
                         , sum(tmpContainer.Amount) OVER () as SummDebt
                    FROM tmpContainer
                    )                     
    -- ������ ����� ������ � ����� �� ������ �������
   , tmpData AS (SELECT tmpData.SummDebt AS SummDebt
                      , SUM ((MI_PartionMI.Amount * MIFloat_OperPriceList.ValueData)
                            - COALESCE (MIFloat_TotalReturn.ValueData, 0) 
                            - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) 
                            - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                            )   AS TotalSumm
                 FROM (SELECT DISTINCT tmpPartion.PartionId_MI , tmpPartion.SummDebt  FROM tmpPartion) AS tmpData
                     
                     LEFT JOIN Object AS Object_PartionMI     ON Object_PartionMI.Id     = tmpData.PartionId_MI
                     LEFT JOIN MovementItem AS MI_PartionMI   ON MI_PartionMI.Id         = Object_PartionMI.ObjectCode
                     LEFT JOIN Movement AS Movement_PartionMI ON Movement_PartionMI.Id   = MI_PartionMI.MovementId 

                     LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                 ON MIFloat_OperPriceList.MovementItemId = MI_PartionMI.Id
                                                AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()                             

                     LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                 ON MIFloat_TotalCountReturn.MovementItemId = MI_PartionMI.Id
                                                AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                     LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                         ON MIFloat_TotalChangePercent.MovementItemId = MI_PartionMI.Id
                                        AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()

                     LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                 ON MIFloat_TotalChangePercentPay.MovementItemId = MI_PartionMI.Id
                                                AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                     LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                 ON MIFloat_TotalReturn.MovementItemId = MI_PartionMI.Id
                                                AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                 GROUP BY tmpData.SummDebt 
                 )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , MovementDate_Insert.ValueData               AS InsertDate

           , MovementFloat_TotalSummPriceList.ValueData  AS TotalSummPriceList

           , MovementFloat_TotalSummChange.ValueData     AS TotalSummChange
           , MovementFloat_TotalSummPay.ValueData        AS TotalSummPay
           , MovementFloat_TotalSummPayOth.ValueData     AS TotalSummPayOth

           , MovementFloat_TotalSummReturn.ValueData     AS TotalSummReturn
           , MovementFloat_TotalSummPayReturn.ValueData  AS TotalSummPayReturn

           , Object_From.ValueData                       AS FromName
           , OS_Unit_Address.ValueData                   AS Address_Unit
           , OS_Unit_Phone.ValueData                     As Phone_Unit
           , Object_To.ValueData                         AS ToName
           
           , tmpDiscount.DiscountTax
           , COALESCE (tmpDiscount.DiscountTax_Next, 0)        :: TFloat AS DiscountTax_Next
           , CASE WHEN ObjectLink_Client_DiscountKind.ChildObjectId = zc_Enum_DiscountKind_Var() THEN TRUE ELSE FALSE END AS isDiscount
           , tmpData.TotalSumm                                 ::TFloat  AS TotalSumm
           , tmpData.SummDebt                                  ::TFloat  AS SummDebt
           , (tmpDiscount.StartSumm_Next - tmpData.TotalSumm)  ::TFloat  AS Discount_diff
         
       FROM  Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId = zc_MovementFloat_TotalSummPriceList()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId = zc_MovementFloat_TotalSummChange()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay.DescId = zc_MovementFloat_TotalSummPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayOth
                                    ON MovementFloat_TotalSummPayOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPayOth.DescId = zc_MovementFloat_TotalSummPayOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummReturn
                                    ON MovementFloat_TotalSummReturn.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummReturn.DescId = zc_MovementFloat_TotalSummReturn()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayReturn
                                    ON MovementFloat_TotalSummPayReturn.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPayReturn.DescId = zc_MovementFloat_TotalSummPayReturn()
                                   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            -- ����� ��������
            LEFT JOIN ObjectString AS OS_Unit_Address
                                   ON OS_Unit_Address.ObjectId = vbUnitId
                                  AND OS_Unit_Address.DescId = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS OS_Unit_Phone
                                   ON OS_Unit_Phone.ObjectId = vbUnitId
                                  AND OS_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

            -- ��� ������ �������
            LEFT JOIN ObjectLink AS ObjectLink_Client_DiscountKind
                                 ON ObjectLink_Client_DiscountKind.ObjectId = vbClientId
                                AND ObjectLink_Client_DiscountKind.DescId = zc_ObjectLink_Client_DiscountKind()
            
            LEFT JOIN tmpDiscount ON tmpDiscount.StartSumm <= MovementFloat_TotalSummPriceList.ValueData
                                 AND tmpDiscount.EndSumm   >= MovementFloat_TotalSummPriceList.ValueData
            LEFT JOIN tmpData ON 1 = 1

      WHERE Movement.Id = inMovementId;
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0)   AS ChangePercent
                           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  AS SummChangePercent
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay
                           , Object_PartionMI.ObjectCode                        AS SaleMI_ID
                           , MovementItem.isErased
                       FROM MovementItem 
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()    
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                             ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                            LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId

                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = false
                       )

       -- ���������
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , Object_Measure.ValueData       AS MeasureName

           , Object_CompositionGroup.ValueData   AS CompositionGroupName  
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.ValueData     AS GoodsSizeName 

           , tmpMI.Amount
           , COALESCE (MIFloat_ChangePercent.ValueData, tmpMI.ChangePercent)      :: TFloat AS ChangePercent

           , tmpMI.OperPrice      ::TFloat
           , tmpMI.CountForPrice  ::TFloat
           , COALESCE (MIFloat_OperPriceList.ValueData, tmpMI.OperPriceList)      :: TFloat AS OperPriceList
           
           , zfCalc_SummIn (tmpMI.Amount, tmpMI.OperPrice, tmpMI.CountForPrice) AS TotalSumm
           , zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList)           AS TotalSummPriceList

             -- ����� � ������
           , (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
            - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
            - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
              -- ��� ��������� �������� (�����������)
            - COALESCE (MIFloat_TotalReturn.ValueData, 0)
            + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
              -- ���� ������� - ������ ������� ����� �� ���. ���������
            + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.TotalPay ELSE 0 END
            + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.SummChangePercent ELSE 0 END
             ) :: TFloat AS TotalSummToPay
             
           , tmpMI.TotalPay                                          :: TFloat  AS TotalPay
           , tmpMI.SummChangePercent                                 :: TFloat  AS SummChangePercent
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
            --
            LEFT JOIN MovementItem AS MI_Sale    ON MI_Sale.Id          = tmpMI.SaleMI_Id
            LEFT JOIN Movement AS Movement_Sale  ON Movement_Sale.Id    = MI_Sale.MovementId
            LEFT JOIN MovementDesc               ON MovementDesc.Id     = Movement_Sale.DescId
            ----
            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                        ON MIFloat_OperPriceList.MovementItemId = MI_Sale.Id
                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
  
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                        ON MIFloat_SummChangePercent.MovementItemId = MI_Sale.Id
                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                        ON MIFloat_TotalChangePercent.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                        ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
  
            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                        ON MIFloat_TotalPay.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                        ON MIFloat_TotalPayOth.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
  
            LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                        ON MIFloat_TotalCountReturn.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
            LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                        ON MIFloat_TotalReturn.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                        ON MIFloat_TotalPayReturn.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 13.02.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Check_Print (inMovementId := 432692, inSession:= '5');
