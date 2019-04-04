-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_OrderGoodsSearch (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderGoodsSearch(
    IN inGoodsId       Integer     -- поиск товаров
  , IN inStartDate     TDateTime
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer      --ИД Документа
              ,ItemName TVarChar       --Название(тип) документа
              ,Amount TFloat           --Кол-во товара в документе
              ,Amount_SpecZakaz TFloat   --Кол-во спецзаказ в заявке внутренней
              ,Amount_ListFiff  TFloat   --Кол-во отказ
              ,Code Integer            --Код товара
              ,Name TVarChar           --Наименование товара
              ,PartnerGoodsName TVarChar  --Наименование поставщика
              ,MakerName  TVarChar     --Производитель
              ,NDSKindName TVarChar    --вид ндс
              ,NDS         TFloat
              ,OperDate TDateTime      --Дата документа
              ,InvNumber TVarChar      --№ документа
              ,UnitName TVarChar       --Подразделение
              ,JuridicalName TVarChar  --Юр. лицо
              ,Price TFloat            --Цена в документе
              ,PriceWithVAT TFloat     --Цена прихода с НДС
              ,PriceSample  TFloat     --Цена СЭМПЛ в  прайс. ценах с НДС
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
              ,InsertName TVarChar     --Пользователь(созд.)
              )


AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
    vbUserId:= lpGetUserBySession (inSession);


    vbUnitKey := COALESCE (lpGet_DefaultValue ('-zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' OR vbUserId = 3 THEN
      vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    IF COALESCE (vbUnitId, 0) = 0
    THEN
        vbRetailId:= zfConvert_StringToFloat (COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '')) :: Integer;
        IF vbRetailId = 4 -- "Не болей"
        THEN vbRetailId:= 0;
        END IF;
    ELSE
        vbRetailId:= 0;
    END IF;


    RETURN QUERY
      WITH tmpGoods AS (-- ???временно захардкодил, будет всегда товар сети???
                        SELECT DISTINCT ObjectLink_Child_to.ChildObjectId AS GoodsId
                        FROM ObjectLink AS ObjectLink_Child
                                INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                         AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Main_to ON ObjectLink_Main_to.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                           AND ObjectLink_Main_to.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Child_to ON ObjectLink_Child_to.ObjectId = ObjectLink_Main_to.ObjectId
                                                                            AND ObjectLink_Child_to.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                      ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_to.ChildObjectId
                                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                INNER JOIN Object ON Object.Id = ObjectLink_Goods_Object.ChildObjectId
                                                 AND Object.DescId = zc_Object_Retail()
                        WHERE ObjectLink_Child.ChildObjectId = inGoodsId
                          AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                       )

      SELECT Movement.Id                              AS MovementId
            ,CASE WHEN Movement.DescId = zc_Movement_Check() THEN 'Продажи касс' ELSE MovementDesc.ItemName END   :: TVarChar AS ItemName
            ,COALESCE(MIFloat_AmountManual.ValueData,
                      MovementItem.Amount)            AS Amount
            ,CASE WHEN Movement.DescId = zc_Movement_OrderInternal() THEN MovementItem.Amount ELSE 0 END   :: TFloat AS Amount_SpecZakaz
            ,CASE WHEN Movement.DescId = zc_Movement_ListDiff() THEN MovementItem.Amount ELSE 0 END        :: TFloat AS Amount_ListFiff
            ,Object.ObjectCode                        AS Code
            ,Object.ValueData                         AS Name
            ,MI_Income_View.PartnerGoodsName          AS PartnerGoodsName
            ,MI_Income_View.MakerName                 AS MakerName

            ,Object_NDSKind.ValueData                 AS NDSKindName
            ,ObjectFloat_NDSKind_NDS.ValueData        AS NDS

            ,Movement.OperDate                        AS OperDate
            ,Movement.InvNumber                       AS InvNumber
            ,Object_Unit.ValueData                    AS UnitName
            ,Object_From.ValueData                    AS JuridicalName
            ,CASE WHEN Movement.DescId = zc_Movement_Check() THEN 0 ELSE MIFloat_Price.ValueData END ::TFloat AS Price
            ,MI_Income_View.PriceWithVAT   ::TFloat
            ,COALESCE (MIFloat_PriceSample.ValueData, 0) ::TFloat AS PriceSample
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

            ,CASE WHEN Movement.DescId = zc_Movement_ListDiff() THEN MIDate_Insert.ValueData ELSE MovementDate_Insert.ValueData END       AS InsertDate
            ,CASE WHEN Movement.DescId = zc_Movement_ListDiff() THEN ObjectMI_Insert.ValueData ELSE Object_Insert.ValueData END AS InsertName

      FROM Movement
        JOIN Object AS Status
                    ON Status.Id = Movement.StatusId
                   AND Status.Id <> zc_Enum_Status_Erased()
        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                         AND MovementItem.isErased = FALSE
        JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

        INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
        LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

   /*     LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                         ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
        LEFT JOIN Object_Goods_View AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId
*/
        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

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
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

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

        LEFT JOIN MovementItemFloat AS MIFloat_PriceSample
                                    ON MIFloat_PriceSample.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSample.DescId = zc_MIFloat_PriceSample()

        LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                          ON MILO_Insert.MovementItemId = MovementItem.Id
                                         AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                                         AND Movement.DescId = zc_Movement_ListDiff()
        LEFT JOIN Object AS ObjectMI_Insert ON ObjectMI_Insert.Id = MILO_Insert.ObjectId

        LEFT JOIN MovementItemDate AS MIDate_Insert
                                   ON MIDate_Insert.MovementItemId = MovementItem.Id
                                  AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                  AND Movement.DescId = zc_Movement_ListDiff()

    WHERE Movement.DescId in (zc_Movement_OrderInternal(), zc_Movement_OrderExternal(), zc_Movement_Income(), zc_Movement_Send(), zc_Movement_Check()
                            , zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_ReturnOut()
                            , zc_Movement_ListDiff()
                            )
      AND Movement.OperDate >= inStartDate AND Movement.OperDate <inEndDate + INTERVAL '1 DAY'
      AND (Object_Unit.Id = vbUnitId OR vbUnitId = 0)
      AND (ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId OR vbRetailId = 0)
      -- AND Object.Id = inGoodsId
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_OrderGoodsSearch (Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 18.12.18         * add  zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_ReturnOut()
 07.01.18         *
 07.01.17         *
 05.09.16         *
 18.07.16         * add zc_Movement_Check
 06.10.15                                                                      *MIFloat_AmountManual
 24.04.15                        *
 18.03.15                        *
 27.01.15                        *
 21.01.15                        *
 02.12.14                        *

*/

-- тест
-- SELECT * FROM gpReport_OrderGoodsSearch (inGoodsId:= 0, inStartDate:= '30.01.2019', inEndDate:= '01.02.2019', inSession:= '2')
