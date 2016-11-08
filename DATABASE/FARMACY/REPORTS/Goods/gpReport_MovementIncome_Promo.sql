-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_MovementIncome_Promo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementIncome_Promo(
    IN inMakerId       Integer     -- Производитель
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer      --ИД Документа
              ,ItemName TVarChar       --Название(тип) документа
              ,Amount TFloat           --Кол-во товара в документе
              ,Amount_SpecZakaz TFloat   --Кол-во спецзаказ в заявке внутренней
              ,Code Integer            --Код товара
              ,Name TVarChar           --Наименование товара
              ,PartnerGoodsName TVarChar  --Наименование поставщика
              ,MakerName  TVarChar     --Производитель
              ,NDSKindName TVarChar    --вид ндс
              ,OperDate TDateTime      --Дата документа
              ,InvNumber TVarChar      --№ документа
              ,UnitName TVarChar       --Подразделение
              ,JuridicalName TVarChar  --Юр. лицо
              ,Price TFloat            --Цена в документе
              ,PriceWithVAT TFloat     --Цена прихода с НДС 
              ,StatusName TVarChar     --Состояние документа
              ,PriceSale TFloat        --Цена продажи
              ,OrderKindId Integer     --ИД вида заказа
              ,OrderKindName TVarChar  --Название вида заказа
              ,Comment  TVarChar       --Комментарий к документу
              ,PartionGoods TVarChar   --№ серии препарата
              ,ExpirationDate TDateTime--Срок годности
              ,PaymentDate TDateTime   --Дата оплаты
              ,InvNumberBranch TVarChar--№ накладной в аптеке
              ,BranchDate TDateTime    --Дата накладной в аптеке
              ,InsertDate TDateTime    --Дата (созд.)
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' OR vbUserId = 3 THEN
      vbUnitKey := '0';
    END IF;   
    vbUnitId := vbUnitKey::Integer;

    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    RETURN QUERY
      WITH 
          -- Товары из Маркетинговых контрактов
          tmpGoods AS (-- всегда товар сети
                       SELECT DISTINCT tmp.JuridicalId                                -- Поставщики
                            , ObjectLink_Child_retail.ChildObjectId AS GoodsId        -- здесь товар "сети"
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= inStartDate) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                                 ON MovementLinkObject_Maker.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                                AND (MovementLinkObject_Maker.ObjectId = inMakerId /*OR inMakerId = 0*/)
                       )

      SELECT Movement.Id                              AS MovementId
            ,CASE WHEN Movement.DescId = zc_Movement_Check() THEN 'Продажи касс' ELSE MovementDesc.ItemName END   :: TVarChar AS ItemName
            ,COALESCE(MIFloat_AmountManual.ValueData,
                      MovementItem.Amount)            AS Amount
            ,CASE WHEN Movement.DescId = zc_Movement_OrderInternal() THEN MovementItem.Amount ELSE 0 END   :: TFloat AS Amount_SpecZakaz
            ,Object.ObjectCode                        AS Code
            ,Object.ValueData                         AS Name
            ,MI_Income_View.PartnerGoodsName          AS PartnerGoodsName
            ,MI_Income_View.MakerName                 AS MakerName

            ,Object_NDSKind.ValueData                 AS NDSKindName
            ,Movement.OperDate                        AS OperDate
            ,Movement.InvNumber                       AS InvNumber
            ,Object_Unit.ValueData                    AS UnitName
            ,Object_From.ValueData                    AS JuridicalName
            ,CASE WHEN Movement.DescId = zc_Movement_Check() THEN 0 ELSE MIFloat_Price.ValueData END ::TFloat AS Price
            ,MI_Income_View.PriceWithVAT   ::TFloat
            ,Status.ValueData                         AS STatusNAme
            ,CASE WHEN Movement.DescId = zc_Movement_Check() THEN MIFloat_Price.ValueData ELSE MIFloat_PriceSale.ValueData END ::TFloat AS PriceSale
            ,Object_OrderKind.Id                      AS OrderKindId
            ,Object_OrderKind.ValueData               AS OrderKindName
            ,CASE WHEN MIString_Comment.ValueData <> '' THEN MIString_Comment.ValueData WHEN MovementString_Comment.ValueData <> '' THEN MovementString_Comment.ValueData ELSE '' END :: TVarChar AS Comment
            ,MIString_PartionGoods.ValueData          AS PartionGoods
            ,MIDate_ExpirationDate.ValueData          AS ExpirationDate
            ,MovementDate_Payment.ValueData           AS PaymentDate
            ,MovementString_InvNumberBranch.ValueData AS InvNumberBranch
            ,MovementDate_Branch.ValueData            AS BranchDate

            ,MovementDate_Insert.ValueData        AS InsertDate
            
      FROM Movement 
        JOIN Object AS Status 
                    ON Status.Id = Movement.StatusId 
                   AND Status.Id <> zc_Enum_Status_Erased()
        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

        JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                         AND MovementItem.isErased = FALSE
        JOIN MovementDesc ON MovementDesc.Id = Movement.DescId


        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       
        INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                           AND tmpGoods.JuridicalId = MovementLinkObject_From.ObjectId
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId 

        LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementItem_Income_View AS MI_Income_View ON MI_Income_View.Id = MovementItem.Id

        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MovementLinkObject_Unit.ObjectId, MovementLinkObject_To.ObjectId)

        LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                     ON MovementLinkObject_OrderKind.MovementId = Movement.Id
                                    AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
        LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.DescId = zc_MovementString_Comment()
                                AND MovementString_Comment.MovementId = Movement.Id
        LEFT JOIN MovementItemString AS MIString_Comment 
                                     ON MIString_Comment.DescId = zc_MIString_Comment()
                                    AND MIString_Comment.MovementItemId = MovementItem.id  

        LEFT JOIN MovementItemString AS MIString_PartionGoods
                                     ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
        LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                   ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                  AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

        LEFT JOIN MovementDate AS MovementDate_Payment
                               ON MovementDate_Payment.MovementId = Movement.Id
                              AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
        
        LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                 ON MovementString_InvNumberBranch.MovementId = Movement.Id
                                AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
        LEFT JOIN MovementDate AS MovementDate_Branch
                               ON MovementDate_Branch.MovementId = Movement.Id
                              AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                    ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

    WHERE Movement.DescId in (zc_Movement_Income(), zc_Movement_Check())
      AND Movement.OperDate BETWEEN inStartDate AND inEndDate 
      AND ((Object_Unit.Id = vbUnitId) OR (vbUnitId = 0)) 
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.11.16         *
*/

-- тест
-- SELECT * FROM gpReport_MovementIncome_Promo (inMakerId:= 0, inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inSession:= '2')
