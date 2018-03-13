-- Function: gpSelect_Movement_GoodsAccount_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_GoodsAccount_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GoodsAccount_Print(
    IN inMovementId        Integer  ,  -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
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
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_GoodsAccountPrint());
     vbUserId:= inSession;

     -- параметры из Документа
     SELECT MovementLinkObject_From.ObjectId AS ClientId
          , MovementLinkObject_To.ObjectId   AS UnitId
          , Movement.StatusId                AS StatusId
            INTO vbClientId, vbUnitId, vbStatusId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
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
           -- выбираю все контейнеры по покупателю и подразделению , если выбрано 
   , tmpContainer AS (SELECT CLO_PartionMI.ObjectId          AS PartionId_MI
                           , Container.Amount
                      FROM Container
                           INNER JOIN ContainerLinkObject AS CLO_Client 
                                                          ON CLO_Client.ContainerId = Container.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                         AND CLO_Client.ObjectId    = vbClientId                            --inClientId --Перцева Наталья 6343  -- 
                           INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                          ON CLO_Unit.ContainerId = Container.Id
                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                         AND CLO_Unit.ObjectId    = vbUnitId
                           LEFT JOIN ContainerLinkObject AS CLO_PartionMI 
                                                         ON CLO_PartionMI.ContainerId = Container.Id
                                                        AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                       -- !!!кроме Покупатели + Прибыль будущих периодов!!!
                       WHERE Container.ObjectId <> zc_Enum_Account_20102() 
                         AND Container.DescId  = zc_Container_Summ()                         
                     ) 
   -- получили конечный долг и у нас все партии продажи
   , tmpPartion AS (SELECT tmpContainer.PartionId_MI
                         , sum(tmpContainer.Amount) OVER () as SummDebt
                    FROM tmpContainer
                    )                     
    -- расчет суммы продаж и оплат по партии продажи
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
           , Object_Status.ObjectCode                    AS StatusCode
           , Object_Status.ValueData                     AS StatusName

           , MovementFloat_TotalSummPay.ValueData        AS TotalSummPay
           , MovementFloat_TotalSummChange.ValueData     AS TotalSummChange

           , Object_From.ValueData                       AS FromName
           , OS_Unit_Address.ValueData                   AS Address_To
           , OS_Unit_Phone.ValueData                     As Phone_To
           , Object_To.ValueData                         AS ToName
           , MovementString_Comment.ValueData            AS Comment
           
           , CASE WHEN ObjectLink_Client_DiscountKind.ChildObjectId = zc_Enum_DiscountKind_Var() THEN TRUE ELSE FALSE END  AS isDiscount
           , tmpData.TotalSumm                                 ::TFloat  AS TotalSumm
           , tmpData.SummDebt                                  ::TFloat  AS SummDebt
         
       FROM  Movement
         
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId     = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
                                  
            -- адрес магазина
            LEFT JOIN ObjectString AS OS_Unit_Address
                                   ON OS_Unit_Address.ObjectId = MovementLinkObject_To.ObjectId
                                  AND OS_Unit_Address.DescId   = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS OS_Unit_Phone
                                   ON OS_Unit_Phone.ObjectId = MovementLinkObject_To.ObjectId
                                  AND OS_Unit_Phone.DescId   = zc_ObjectString_Unit_Phone()
                                  
            -- вид скидки клиента
            LEFT JOIN ObjectLink AS ObjectLink_Client_DiscountKind
                                 ON ObjectLink_Client_DiscountKind.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Client_DiscountKind.DescId   = zc_ObjectLink_Client_DiscountKind()
            
            LEFT JOIN tmpData ON 1 = 1

      WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_GoodsAccount();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH
       tmpMI_Master AS (SELECT MI_Master.Id                                              AS Id
                             , MI_Master.PartionId                                       AS PartionId
                             , MI_Master.ObjectId                                        AS GoodsId
                             , MI_Master.Amount                                          AS Amount
                             , COALESCE (MIFloat_SummChangePercent_master.ValueData, 0)  AS SummChangePercent
                             , COALESCE (MIFloat_TotalPay_master.ValueData, 0)           AS TotalPay
                             , COALESCE (MIString_Comment_master.ValueData,'')           AS Comment
                             , MI_Master.isErased                                        AS isErased
                             , ROW_NUMBER() OVER (PARTITION BY MI_Master.isErased ORDER BY MI_Master.Id ASC) AS Ord

                             , Object_PartionMI.ObjectCode                               AS SaleMI_ID

                        FROM MovementItem AS MI_Master
                             LEFT JOIN MovementItemString AS MIString_Comment_master
                                                          ON MIString_Comment_master.MovementItemId = MI_Master.Id
                                                         AND MIString_Comment_master.DescId         = zc_MIString_Comment()

                             LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_master
                                                         ON MIFloat_SummChangePercent_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_SummChangePercent_master.DescId         = zc_MIFloat_SummChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_master
                                                         ON MIFloat_TotalPay_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay_master.DescId         = zc_MIFloat_TotalPay()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                              ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                             AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                       WHERE MI_Master.MovementId = inMovementId
                                              AND MI_Master.DescId     = zc_MI_Master()
                                              AND MI_Master.isErased   = FALSE
                       )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0) AS ParentId
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- Расчетная сумма в грн для обмен
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END) AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END)                                                 AS Amount_Bank

                      FROM MovementItem
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()

                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      WHERE MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = FALSE
                      GROUP BY MovementItem.ParentId
                     )

       -- результат
       SELECT
             tmpMI.Id                                          :: Integer AS Id
           , tmpMI.PartionId                                   :: Integer AS PartionId
           , Object_Goods.Id                                              AS GoodsId
           , Object_Goods.ObjectCode                                      AS GoodsCode
           , Object_Goods.ValueData                                       AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData                  AS GoodsGroupNameFull
           , Object_Measure.ValueData                                     AS MeasureName
           , Object_CompositionGroup.ValueData                            AS CompositionGroupName
           , Object_Composition.ValueData                                 AS CompositionName
           , Object_GoodsInfo.ValueData                                   AS GoodsInfoName
           , Object_LineFabrica.ValueData                                 AS LineFabricaName
           , Object_Label.ValueData                                       AS LabelName
           , Object_GoodsSize.Id                                          AS GoodsSizeId
           , Object_GoodsSize.ValueData                                   AS GoodsSizeName

           , tmpMI.Amount                                       :: TFloat AS Amount
           , MI_Sale.Amount                                     :: TFloat AS Amount_Sale
           , COALESCE (MIFloat_OperPriceList.ValueData, 0)      :: TFloat AS OperPriceList

             -- Итого сумма (в прод.)
           , zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData) AS TotalSummPriceList

             -- Итого сумма оплаты - для "текущего" документа Продажи
           , COALESCE (MIFloat_TotalPay.ValueData, 0)           ::TFloat AS TotalPay_Sale
             -- Итого сумма оплаты - все "Расчеты покупателей"
           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)        ::TFloat AS TotalPayOth_Sale

             -- Итого сумма возврата оплаты - все док-ты
           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)   ::TFloat AS Amount_Return
             -- Итого сумма возврата оплаты - все док-ты
           , COALESCE (MIFloat_TotalReturn.ValueData, 0)        ::TFloat AS TotalReturn
             -- Итого сумма возврата оплаты - все док-ты
           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)     ::TFloat AS TotalPay_Return

             -- Сумма долга
           , (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
            - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
            - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
              -- так минуснули Возвраты (проведенные)
            - COALESCE (MIFloat_TotalReturn.ValueData, 0)
            + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
              -- если НЕ ПРОВЕЛИ - уменьшаем Долг на сумму из тек. документа
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.TotalPay ELSE 0 END
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.SummChangePercent ELSE 0 END
             ) :: TFloat AS SummDebt

             -- % Скидки
           , COALESCE (MIFloat_ChangePercent.ValueData, 0)      :: TFloat AS ChangePercent
             -- Итого сумма Скидки - для "текущего" документа Продажи: 2)дополнительная
           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  :: TFloat AS SummChangePercent_sale
             -- Итого сумма Скидки - для "текущего" документа Продажи: 1)по %скидки
           , (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) - COALESCE (MIFloat_SummChangePercent.ValueData, 0)) :: TFloat AS TotalChangePercent_sale
             -- Итого сумма Скидки - все "Расчеты покупателей"
           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) :: TFloat AS TotalChangePercentPay

             -- Сумма к оплате
           , (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
            - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
            - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
              -- так минуснули Возвраты (проведенные)
            - COALESCE (MIFloat_TotalReturn.ValueData, 0)
            + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
              -- если ПРОВЕЛИ - вернем обратно суммы из тек. документа
            + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.TotalPay ELSE 0 END
            + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.SummChangePercent ELSE 0 END
             ) :: TFloat AS TotalSummToPay

           , tmpMI_Child.Amount_GRN                             :: TFloat AS TotalPay_Grn
           , tmpMI_Child.Amount_USD                             :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR                             :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank                            :: TFloat AS TotalPay_Card
           , tmpMI.TotalPay                                     :: TFloat AS TotalPay
           , tmpMI.SummChangePercent                            :: TFloat AS SummChangePercent

           , tmpMI_Child_Exc.Amount_USD                         :: TFloat AS Amount_USD_Exc    -- Сумма USD - обмен приход
           , tmpMI_Child_Exc.Amount_EUR                         :: TFloat AS Amount_EUR_Exc    -- Сумма EUR - обмен приход
           , tmpMI_Child_Exc.Amount_GRN                         :: TFloat AS Amount_GRN_Exc    -- Сумма GRN - обмен расход

           , tmpMI.SaleMI_ID                                   :: Integer AS SaleMI_Id
           , Movement_Sale.Id                                             AS MovementId_Sale
           , Movement_Sale.InvNumber                                      AS InvNumber_Sale
           , Movement_Sale.OperDate                                       AS OperDate_Sale
           , MovementDesc.ItemName                                        AS DescName
           , tmpMI.Comment                                    :: TVarChar AS Comment
           , tmpMI.isErased                                               AS isErased

       FROM tmpMI_Master AS tmpMI
            -- суммы оплаты
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            -- суммы обмена
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 13.02.18         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_GoodsAccount_Print (inMovementId := 432692, inSession:= '5');
