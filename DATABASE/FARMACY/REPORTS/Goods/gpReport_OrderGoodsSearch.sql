-- Function: gpReport_OrderGoodsSearch()

DROP FUNCTION IF EXISTS gpReport_OrderGoodsSearch (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderGoodsSearch(
    IN inGoodsId       Integer     -- поиск товаров
  , IN inStartDate     TDateTime
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer      --ИД Документа
              ,MovementItemId Integer      --ИД Строки Документа
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
              ,JuridicalName_Our TVarChar -- наше юр.лицо
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
              ,PriceSite TFloat
              ,isSupplierFailures Boolean
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
    WITH tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                 ),
     tmpGoods AS (-- ???временно захардкодил, будет всегда товар сети???
                  SELECT Object_Goods_Retail.Id                   AS GoodsId
                        , Object_Goods_Main.ObjectCode             AS Code
                        , Object_Goods_Main.Name                   AS Name
                        , Object_NDSKind.ValueData                 AS NDSKindName
                        , ObjectFloat_NDSKind_NDS.ValueData        AS NDS
                   FROM Object_Goods_Retail AS Object_Goods_4
                        LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_4.GoodsMainId
                        LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_4.GoodsMainId
                        LEFT JOIN tmpOF_NDSKind_NDS AS ObjectFloat_NDSKind_NDS
                                                    ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = Object_Goods_Main.NDSKindId
                   WHERE Object_Goods_4.Id = inGoodsId
                       ),
     tmpMovementItem AS (SELECT MovementItem.MovementId AS MovementId
                              , MovementItem.Id         AS MovementItemId
                              , MovementItem.ParentId   AS ParentId
                              , MovementItem.ObjectId
                              , MovementItem.Amount
                         FROM MovementItem
                         WHERE MovementItem.isErased = FALSE
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.ObjectId in (SELECT tmpGoods.GoodsId FROM tmpGoods)),
     tmpMovement AS (SELECT Movement.Id
                          , Movement.DescId
                          , Movement.OperDate
                          , Movement.InvNumber
                          , Movement.StatusId
                          , MovementItem.MovementItemId
                          , MovementItem.ParentId
                          , MovementItem.ObjectId
                          , MovementItem.Amount
                          , CASE WHEN Movement.DescId = zc_Movement_ListDiff() THEN MIDate_Insert.ValueData
                                 WHEN Movement.DescId = zc_Movement_OrderExternal() THEN MovementDate_Update.ValueData
                                 ELSE MovementDate_Insert.ValueData
                            END AS InsertDate
                          , CASE WHEN Movement.DescId = zc_Movement_ListDiff() THEN ObjectMI_Insert.ValueData
                                 WHEN Movement.DescId = zc_Movement_OrderExternal() THEN Object_Update.ValueData
                                 ELSE Object_Insert.ValueData
                            END AS InsertName
                          , MILinkObject_Goods.ObjectId           AS GoodsJuridicalId
                     FROM tmpMovementItem AS MovementItem

                          INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
                                             AND Movement.DescId in (zc_Movement_OrderInternal(), zc_Movement_OrderExternal(), zc_Movement_Income(), zc_Movement_Send(), zc_Movement_Check()
                                                                    , zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_ReturnOut()
                                                                    , zc_Movement_ListDiff()
                                                                    )
                                              AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'

                          LEFT JOIN MovementDate AS MovementDate_Insert
                                                 ON MovementDate_Insert.MovementId = Movement.Id
                                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                          LEFT JOIN MovementLinkObject AS MLO_Insert
                                                       ON MLO_Insert.MovementId = Movement.Id
                                                      AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                          -- для заказа внутреннего Дата отправки и польз. отправки
                          LEFT JOIN MovementDate AS MovementDate_Update
                                                 ON MovementDate_Update.MovementId = Movement.Id
                                                AND MovementDate_Update.DescId = zc_MovementDate_Update()
                                                AND Movement.DescId = zc_Movement_OrderExternal()
                          LEFT JOIN MovementLinkObject AS MLO_Update
                                                       ON MLO_Update.MovementId = Movement.Id
                                                      AND MLO_Update.DescId = zc_MovementLinkObject_Update()
                                                      AND Movement.DescId = zc_Movement_OrderExternal()
                          LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

                          LEFT JOIN MovementItemDate AS MIDate_Insert
                                                     ON MIDate_Insert.MovementItemId = MovementItem.MovementItemId
                                                    AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                                    AND Movement.DescId = zc_Movement_ListDiff()

                          LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                           ON MILO_Insert.MovementItemId = MovementItem.MovementItemId
                                                          AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                          LEFT JOIN Object AS ObjectMI_Insert ON ObjectMI_Insert.Id = MILO_Insert.ObjectId

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                           ON MILinkObject_Goods.MovementItemId = MovementItem.MovementItemId
                                                          AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()                                                          
                          ),
     tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovement.MovementItemId  FROM tmpMovement)
                         ),
     tmpMIString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMovement.MovementItemId  FROM tmpMovement)
                         ),
     tmpMLObject AS (SELECT * FROM MovementLinkObject WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id  FROM tmpMovement)
                         ),

     tmpMILO_DiffKind AS (SELECT MovementItemLinkObject.*
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovement.MovementItemId FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_ListDiff())
                                  AND MovementItemLinkObject.DescId = zc_MILinkObject_DiffKind()
                                ),

     tmpMIF_ListDiff AS (SELECT MovementItemFloat.*
                               FROM MovementItemFloat
                               WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovement.MovementItemId FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_OrderInternal())
                                  AND MovementItemFloat.DescId = zc_MIFloat_ListDiff()
                               ),
     tmpGoods_Juridical AS (SELECT * FROM Object_Goods_Juridical WHERE Object_Goods_Juridical.Id IN (SELECT DISTINCT tmpMovement.GoodsJuridicalId  FROM tmpMovement)
                            ),
     tmpPrice_Site AS (SELECT Object_PriceSite.Id                        AS Id
                            , ROUND(Price_Value.ValueData,2)::TFloat     AS Price
                            , Price_Goods.ChildObjectId                  AS GoodsId
                       FROM Object AS Object_PriceSite
                            INNER JOIN ObjectLink AS Price_Goods
                                    ON Price_Goods.ObjectId = Object_PriceSite.Id
                                   AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                   AND Price_Goods.ChildObjectId = inGoodsId
                            LEFT JOIN ObjectFloat AS Price_Value
                                   ON Price_Value.ObjectId = Object_PriceSite.Id
                                  AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                       WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                         AND Price_Goods.ChildObjectId NOT IN (SELECT DISTINCT ObjectLink_BarCode_Goods.ChildObjectId  AS GoodsId
                                                               FROM Object AS Object_BarCode
                                                                    LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                                         ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                                                        AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                                                    LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                                         ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                                                        AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                                                    LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           
                                                               WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                                                 AND Object_BarCode.isErased = False
                                                                 AND Object_Object.isErased = False)
                      ),
     tmpSupplierFailures AS (SELECT DISTINCT 
                                    tmp.OperDate
                                  , tmp.DateFinal
                                  , tmp.UnitId
                                  , tmp.JuridicalId
                             FROM lpSelect_PriceList_SupplierFailuresGoods (inGoodsId := inGoodsId, inUnitId := 0, inUserId := vbUserId) AS tmp)

      --
      SELECT Movement.Id                              AS MovementId
            ,Movement.MovementItemId                  AS MovementItemId
            ,CASE WHEN Movement.DescId = zc_Movement_Check() THEN 'Продажи касс' ELSE MovementDesc.ItemName END   :: TVarChar AS ItemName
            ,COALESCE(MIFloat_AmountManual.ValueData,
                      Movement.Amount)            AS Amount
            ,CASE WHEN Movement.DescId = zc_Movement_OrderInternal() THEN Movement.Amount ELSE 0 END   :: TFloat AS Amount_SpecZakaz
            ,CASE WHEN Movement.DescId = zc_Movement_ListDiff() THEN Movement.Amount
                  WHEN Movement.DescId = zc_Movement_OrderInternal() THEN COALESCE (tmpMIF_ListDiff.ValueData, 0)
                  ELSE 0
             END        :: TFloat AS Amount_ListFiff
            ,Goods_NDS.Code                           AS Code
            ,Goods_NDS.Name                           AS Name
            ,COALESCE(MIString_GoodsName.ValueData, 
                      Object_PartnerGoods.Name)       AS PartnerGoodsName
            ,COALESCE(MIString_MakerName.ValueData, 
                      Object_PartnerGoods.MakerName)  AS MakerName

            ,Goods_NDS.NDSKindName                    AS NDSKindName
            ,Goods_NDS.NDS                            AS NDS

            ,Movement.OperDate                        AS OperDate
            ,Movement.InvNumber                       AS InvNumber
            ,Object_Unit.ValueData                    AS UnitName
            ,Object_JuridicalOur.ValueData            AS JuridicalName_Our
            ,Object_From.ValueData                    AS JuridicalName
            ,CASE WHEN Movement.DescId = zc_Movement_Check() THEN 0
                  WHEN Movement.DescId = zc_Movement_OrderInternal() THEN MIFloat_JuridicalPrice.ValueData
                  ELSE MIFloat_Price.ValueData
             END ::TFloat AS Price
            ,COALESCE(MIFloat_PriceWithVAT.ValueData, 
                      CASE WHEN  Movement.DescId <> zc_Movement_Income() THEN NULL
                           WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData, TRUE) THEN MIFloat_Price.ValueData
                           ELSE (MIFloat_Price.ValueData * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)/100)) END) ::TFloat  AS PriceWithVAT 
            ,COALESCE (MIFloat_PriceSample.ValueData, 0) ::TFloat AS PriceSample
            ,Status.ValueData                         AS STatusNAme
            ,CASE WHEN Movement.DescId = zc_Movement_Check() THEN MIFloat_Price.ValueData ELSE MIFloat_PriceSale.ValueData END ::TFloat AS PriceSale
            ,Object_OrderKind.Id                      AS OrderKindId
            ,Object_OrderKind.ValueData               AS OrderKindName
            ,CASE WHEN MIString_Comment.ValueData <> '' THEN MIString_Comment.ValueData
                  WHEN MovementString_Comment.ValueData <> '' THEN MovementString_Comment.ValueData
                  WHEN Movement.DescId = zc_Movement_ListDiff() THEN COALESCE (Object_DiffKind.ValueData,'')
                  ELSE '' END :: TVarChar AS Comment
            ,MIString_PartionGoods.ValueData          AS PartionGoods
            ,MIDate_ExpirationDate.ValueData          AS ExpirationDate
            ,MovementDate_Payment.ValueData           AS PaymentDate
            ,MovementString_InvNumberBranch.ValueData AS InvNumberBranch
            ,MovementDate_Branch.ValueData            AS BranchDate

            ,Movement.InsertDate
            ,Movement.InsertName
            
            ,tmpPrice_Site.Price                      AS PriceSite
            
            ,COALESCE (tmpSupplierFailures.UnitId, 0) > 0 AS isSupplierFailures

      FROM tmpMovement AS Movement

        INNER JOIN Object AS Status
                          ON Status.Id = Movement.StatusId
                         --AND Status.Id <> zc_Enum_Status_Erased()    -- 03.06.2019 -  по просьбе Любы

        JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

        LEFT JOIN tmpGoods AS Goods_NDS
                           ON Goods_NDS.GoodsId = Movement.ObjectId

        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                     ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

        LEFT JOIN tmpGoods_Juridical AS Object_PartnerGoods 
                                     ON Object_PartnerGoods.Id = Movement.GoodsJuridicalId 

        LEFT JOIN tmpMIString AS MIString_MakerName
                                     ON MIString_MakerName.MovementItemId = Movement.MovementItemId
                                    AND MIString_MakerName.DescId = zc_MIString_Maker()
        LEFT JOIN tmpMIString AS MIString_GoodsName
                                     ON MIString_GoodsName.MovementItemId = Movement.MovementItemId
                                    AND MIString_GoodsName.DescId = zc_MIString_GoodsName()

        LEFT JOIN tmpMIFloat AS MIFloat_Price
                             ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN tmpMIFloat AS MIFloat_PriceWithVAT
                             ON MIFloat_PriceWithVAT.MovementItemId = Movement.MovementItemId
                            AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

        LEFT JOIN tmpMIFloat AS MIFloat_JuridicalPrice
                             ON MIFloat_JuridicalPrice.MovementItemId = Movement.MovementItemId
                            AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                            AND Movement.DescId = zc_Movement_OrderInternal()

        LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                             ON MIFloat_PriceSale.MovementItemId = CASE WHEN Movement.DescId = zc_Movement_ReturnOut() THEN  Movement.ParentId ELSE Movement.MovementItemId END
                            AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

        LEFT JOIN tmpMLObject AS MovementLinkObject_Unit
                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN tmpMLObject AS MovementLinkObject_To
                              ON MovementLinkObject_To.MovementId = Movement.Id
                             AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnOut() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MovementLinkObject_Unit.ObjectId, MovementLinkObject_To.ObjectId)

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_JuridicalOur ON Object_JuridicalOur.Id = ObjectLink_Unit_Juridical.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

        LEFT JOIN tmpMLObject AS MovementLinkObject_From
                              ON MovementLinkObject_From.MovementId = Movement.Id
                             AND MovementLinkObject_From.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnOut() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

        LEFT JOIN tmpMLObject AS MovementLinkObject_OrderKind
                              ON MovementLinkObject_OrderKind.MovementId = Movement.Id
                             AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
        LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.DescId = zc_MovementString_Comment()
                                AND MovementString_Comment.MovementId = Movement.Id
        LEFT JOIN tmpMIString AS MIString_Comment
                                     ON MIString_Comment.DescId = zc_MIString_Comment()
                                    AND MIString_Comment.MovementItemId = Movement.MovementItemId

        LEFT JOIN tmpMIString AS MIString_PartionGoods
                                     ON MIString_PartionGoods.MovementItemId = Movement.MovementItemId
                                    AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
        LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                   ON MIDate_ExpirationDate.MovementItemId = CASE WHEN Movement.DescId = zc_Movement_ReturnOut() THEN  Movement.ParentId ELSE Movement.MovementItemId END
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
        LEFT JOIN tmpMIFloat AS MIFloat_AmountManual
                             ON MIFloat_AmountManual.MovementItemId = Movement.MovementItemId
                            AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

        LEFT JOIN tmpMIFloat AS MIFloat_PriceSample
                             ON MIFloat_PriceSample.MovementItemId = Movement.MovementItemId
                            AND MIFloat_PriceSample.DescId = zc_MIFloat_PriceSample()

        LEFT JOIN tmpMILO_DiffKind ON tmpMILO_DiffKind.MovementItemId = Movement.MovementItemId
                                  AND Movement.DescId = zc_Movement_ListDiff()
        LEFT JOIN Object AS Object_DiffKind ON Object_DiffKind.Id = tmpMILO_DiffKind.ObjectId

        LEFT JOIN tmpMIF_ListDiff ON tmpMIF_ListDiff.MovementItemId = Movement.MovementItemId
                                 AND Movement.DescId = zc_Movement_OrderInternal()
                                 
        LEFT JOIN tmpPrice_Site ON 1 = 1 
        
        LEFT JOIN tmpSupplierFailures ON tmpSupplierFailures.OperDate    <= Movement.OperDate
                                     AND tmpSupplierFailures.DateFinal   > Movement.OperDate
                                     AND tmpSupplierFailures.UnitId      = COALESCE(MovementLinkObject_Unit.ObjectId, MovementLinkObject_To.ObjectId)
                                     AND tmpSupplierFailures.JuridicalId = MovementLinkObject_From.ObjectId 
                                     AND Movement.DescId                 = zc_Movement_OrderExternal()

    WHERE (Object_Unit.Id = vbUnitId OR vbUnitId = 0)
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
 19.11.20         *
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
--SELECT * FROM gpReport_OrderGoodsSearch (inGoodsId:= 9247, inStartDate:= '01.01.2019', inEndDate:= '01.12.2019', inSession:= '183242')
--select * from gpReport_OrderGoodsSearch(inGoodsId := 2848982 , inStartDate := ('01.10.2020')::TDateTime , inEndDate := ('31.10.2020')::TDateTime ,  inSession := '3');

select * from gpReport_OrderGoodsSearch(inGoodsId := 22306 , inStartDate := ('01.03.2022')::TDateTime , inEndDate := ('25.03.2022')::TDateTime ,  inSession := '3');
