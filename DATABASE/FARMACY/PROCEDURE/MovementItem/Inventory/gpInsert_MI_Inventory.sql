-- Function: gpInsert_MI_Inventory()

DROP FUNCTION IF EXISTS gpInsert_MI_Inventory (Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Inventory(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inBarCode             TVarChar  , -- штрихкод товара
    IN inAmountUser          TFloat    , -- Количество тек.пользователя
   OUT outGoodsCode          Integer   ,
   OUT outGoodsName          TVarChar  , 
   OUT outAmountAdd          TFloat    ,    
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPrice TFloat;
   DECLARE vbAmount TFloat;
   DECLARE vbCountUser TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

    IF TRIM(COALESCE(inBarCode, '')) = ''
    THEN
      RAISE EXCEPTION 'Штрихкод не заполнен.';
    END IF;

    inBarCode := TRIM(COALESCE(inBarCode, ''));

    IF COALESCE (inAmountUser,0) = 0
    THEN
      inAmountUser := 1;
    END IF;

    --определяем подразделение и дату документа
    SELECT DATE_TRUNC ('DAY', Movement.OperDate)
         , MLO_Unit.ObjectId
    INTO vbOperDate, vbUnitId
    FROM Movement
        INNER JOIN MovementLinkObject AS MLO_Unit
                                      ON MLO_Unit.MovementId = Movement.Id
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    -- !!! - определяется <Торговая сеть>!!!
    vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 );

    IF SUBSTR (inBarCode, 1, 1) = '2'
    THEN
      --определяем товар по внутреннему штришкоду
      vbGoodsId := (SELECT ObjectLink_Child.ChildObjectId
                    FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS GoodsId) AS tmp
                         LEFT JOIN ObjectLink AS ObjectLink_Main
                                ON ObjectLink_Main.ChildObjectId = tmp.GoodsId    --ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                               AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                         LEFT JOIN ObjectLink AS ObjectLink_Child
                                ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                               AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                         -- связь с Торговая сеть или ...
                         INNER JOIN ObjectLink AS ObjectLink_Goods_Retail
                                 ON ObjectLink_Goods_Retail.ObjectId = ObjectLink_Child.ChildObjectId
                                AND ObjectLink_Goods_Retail.DescId = zc_ObjectLink_Goods_Object()
                                AND ObjectLink_Goods_Retail.ChildObjectId = vbObjectId
                         /*INNER JOIN Object AS Object_GoodsObject
                                   ON Object_GoodsObject.Id = ObjectLink_Goods_Retail.ChildObjectId
                                  AND COALESCE (Object_GoodsObject.DescId, 0) = zc_Object_Retail()*/
                    );
    ELSE
      --определяем товар по штришкоду производителя
      IF (SELECT count(*)
                    FROM ObjectLink AS ObjectLink_Main_BarCode
                         JOIN ObjectLink AS ObjectLink_Child_BarCode
                                         ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                        AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                         JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                         ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                        AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                        AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                         LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_Main
                                              ON ObjectLink_Main.ChildObjectId = ObjectLink_Main_BarCode.ChildObjectId
                                             AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                         LEFT JOIN ObjectLink AS ObjectLink_Child
                                              ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                             AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                              -- связь с Торговая сеть или ...
                         INNER JOIN ObjectLink AS ObjectLink_Goods_Retail
                                              ON ObjectLink_Goods_Retail.ObjectId = ObjectLink_Child.ChildObjectId
                                             AND ObjectLink_Goods_Retail.DescId = zc_ObjectLink_Goods_Object()
                                             AND ObjectLink_Goods_Retail.ChildObjectId = vbObjectId
                    WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                      AND ObjectLink_Main_BarCode.ChildObjectId > 0
                      AND Object_Goods_BarCode.ValueData Like '%'||inBarCode||'%') > 1
      THEN
        RAISE EXCEPTION 'Штрихкод прикреплен к более чем одному товару.';
      ELSE
        vbGoodsId := (SELECT ObjectLink_Child.ChildObjectId
                      FROM ObjectLink AS ObjectLink_Main_BarCode
                           JOIN ObjectLink AS ObjectLink_Child_BarCode
                                           ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                          AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                           JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                           ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                          AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                          AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                           LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
  
                           LEFT JOIN ObjectLink AS ObjectLink_Main
                                                ON ObjectLink_Main.ChildObjectId = ObjectLink_Main_BarCode.ChildObjectId
                                               AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                           LEFT JOIN ObjectLink AS ObjectLink_Child
                                                ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                               AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                -- связь с Торговая сеть или ...
                           INNER JOIN ObjectLink AS ObjectLink_Goods_Retail
                                                ON ObjectLink_Goods_Retail.ObjectId = ObjectLink_Child.ChildObjectId
                                               AND ObjectLink_Goods_Retail.DescId = zc_ObjectLink_Goods_Object()
                                               AND ObjectLink_Goods_Retail.ChildObjectId = vbObjectId
                      WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                        AND ObjectLink_Main_BarCode.ChildObjectId > 0
                        AND Object_Goods_BarCode.ValueData Like '%'||inBarCode||'%'
                      LIMIT 1);
      END IF;
    END IF;

    IF COALESCE(vbGoodsId, 0) = 0
    THEN
      RAISE EXCEPTION 'Товар по штрихкоду <%> не найден.', inBarCode;
    END IF;

    --определяем ИД строки
    vbId := (SELECT MovementItem.Id
             FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.ObjectId = vbGoodsId);


    -- Нужно определить итого кол-во (последнее кол-во по всем пользователям + текущее)
    -- и кол-во пользователей, сформировавших остаток
    SELECT SUM (tmp.Amount) AS  Amount
         , (Count (tmp.Num) + 1) :: TFloat AS CountUser
    INTO vbAmount, vbCountUser
    FROM (SELECT MovementItem.Amount        AS Amount
               , CAST (ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS Num
          FROM MovementItem
               LEFT JOIN MovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MovementItem.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
          WHERE MovementItem.ParentId = vbId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased  = FALSE
            AND MovementItem.ObjectId  <> vbUserId
           ) AS tmp
    WHERE tmp.Num = 1;

    vbAmount := COALESCE (inAmountUser,0) + COALESCE (vbAmount, 0);
    -- определяем цену
    vbPrice := (SELECT ROUND(Price_Value.ValueData,2)::TFloat
                FROM ObjectLink AS Price_Unit
                       INNER JOIN ObjectLink AS Price_Goods
                                             ON Price_Goods.ObjectId = Price_Unit.ObjectId
                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                            AND Price_Goods.ChildObjectId = vbGoodsId
                       LEFT JOIN ObjectFloat AS Price_Value
                                             ON Price_Value.ObjectId = Price_Unit.ObjectId
                                            AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                WHERE Price_Unit.ChildObjectId = vbUnitId
                  AND Price_Unit.DescId = zc_ObjectLink_Price_Unit());

    -- Расчитываем сумму по строке
    --outSumm := (vbAmount * vbPrice)::TFloat;

    -- сохранили
    vbId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE(vbId,0)
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := vbGoodsId
                                                , inAmount             := vbAmount
                                                , inPrice              := vbPrice
                                                , inSumm               := (vbAmount * vbPrice)::TFloat --outSumm
                                                , inComment            := '' ::TVarChar
                                                , inUserId             := vbUserId) AS tmp;

    -- Записываем подчиненный элемент
    IF COALESCE(vbId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_MI_Inventory_Child(inId                 := 0
                                                , inMovementId         := inMovementId
                                                , inParentId           := vbId
                                                , inAmountUser         := inAmountUser
                                                , inUserId             := vbUserId
                                                  );
    END IF;
    
    
    SELECT
      ObjectCode,
      ValueData
    INTO
      outGoodsCode,
      outGoodsName
    FROM Object 
    WHERE ID = vbGoodsId;
   
    outAmountAdd := inAmountUser;  
    --

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий О.В.
 17.04.19                                                                                      *
 10.04.19                                                                                    *
 01.03.17         *
*/

-- тест
-- select * from gpInsert_MI_Inventory(inMovementId := 7784548 , inBarCode := '4047642001824' , inAmountUser := 1 ,  inSession := '3354092');