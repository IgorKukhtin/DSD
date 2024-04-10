 -- Function: gpUpdate_Object_Goods_In(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_In (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_In(
    IN inStartDate           TDateTime,    --
    IN inEndDate             TDateTime,    --
    IN inSession             TVarChar
)

RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());

      -- ???сохраняем???
      PERFORM gpInsertUpdate_Object_JuridicalDefermentPayment (inStartDate:= DATE_TRUNC ('YEAR', CURRENT_DATE), inEndDate:= CURRENT_DATE, inSession:= inSession);

      -- ограничиваем товар
      CREATE TEMP TABLE tmpGoods (GoodsId Integer) ON COMMIT DROP;
      INSERT INTO tmpGoods (GoodsId)
        SELECT DISTINCT Object_Goods.Id AS GoodsId
        FROM Object_InfoMoney_View
             JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                            AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
             JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_Goods_InfoMoney.ObjectId
                                     -- AND Object_Goods.isErased = FALSE
        WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты
                                                             , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                             , zc_Enum_InfoMoneyDestination_20300() -- МНМА
                                                             , zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                              );
      --WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
      --                                                      );



      -- сохраняем свойства
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_In(),         tmpDataAll.GoodsId, tmpDataAll.OperDate)              -- <Дата посл. прихода>
            , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_AmountIn(), tmpDataAll.GoodsId, tmpDataAll.Amount)                -- <Кол-во посл. прихода>
            , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PriceIn(),  tmpDataAll.GoodsId, tmpDataAll.Price)                 -- <Цена посл. прихода>
            , lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_PartnerIn(),  tmpDataAll.GoodsId, MovementLinkObject_From.ObjectId) -- <Поставщик>
            -- , lpInsert_ObjectProtocol (inObjectId:= tmpDataAll.GoodsId, inUserId:= vbUserId, inIsUpdate:= FALSE)
      FROM (-- берем последний документ прихода
            SELECT tmpDataAll.*
            FROM -- все документы прихода
                (SELECT MovementItem.ObjectId             AS GoodsId
                      , Movement.Id                       AS MovementId
                      , Movement.OperDate                 AS OperDate
                      , COALESCE (MovementItem.Amount, 0) AS Amount
                      , CASE WHEN Movement.isPriceWithVAT = TRUE OR Movement.VATPercent = 0
                                -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                                THEN CASE WHEN Movement.ChangePercent <> 0
                                               THEN CAST (MIF_Price.ValueData * (1 + Movement.ChangePercent / 100) AS NUMERIC (16, 2))
                                          ELSE MIF_Price.ValueData
                                     END
                             WHEN Movement.VATPercent > 0
                                -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                                THEN CASE WHEN Movement.ChangePercent <> 0 THEN CAST (MIF_Price.ValueData * (1 + Movement.VATPercent / 100) * (1 + Movement.ChangePercent / 100) AS NUMERIC (16, 2))
                                          ELSE CAST (MIF_Price.ValueData * (1 + Movement.VATPercent / 100) AS NUMERIC (16, 2))
                                     END
                        END AS Price

                      , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) as Ord
                 FROM (SELECT Movement.Id
                            , Movement.OperDate
                            , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS isPriceWithVAT
                            , COALESCE (MovementFloat_VATPercent.ValueData, 0.0)      AS VATPercent
                            , COALESCE (MovementFloat_ChangePercent.ValueData, 0.0)   AS ChangePercent
                       FROM Movement
                            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                    ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate  -- '01.09.2018' AND '18.10.2018'  --
                         AND Movement.DescId = zc_Movement_Income()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                      ) AS Movement
                      LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                      LEFT JOIN MovementItemFloat AS MIF_Price
                                                  ON MIF_Price.MovementItemId = MovementItem.Id
                                                 AND MIF_Price.DescId         = zc_MIFloat_Price()
                      INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                 WHERE MovementItem.Amount > 0 AND MIF_Price.ValueData > 0
                 ) AS tmpDataAll
            WHERE tmpDataAll.Ord = 1

           ) AS tmpDataAll
           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = tmpDataAll.MovementId
                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          ;

END;
$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.10.18         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Goods_In (inStartDate:= CURRENT_DATE - INTERVAL '12 MONTH' , inEndDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
