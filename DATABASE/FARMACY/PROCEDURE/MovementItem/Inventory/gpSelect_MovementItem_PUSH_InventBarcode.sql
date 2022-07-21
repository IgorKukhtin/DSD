-- Function: gpSelect_MovementItem_PUSH_InventBarcode()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PUSH_InventBarcode (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PUSH_InventBarcode(
    IN inMovementId        Integer  , -- ключ Документа
    IN inBarCode           TVarChar , -- json     
   OUT outShowMessage      Boolean  , -- Показыват сообщение
   OUT outPUSHType         Integer  , -- Тип сообщения
   OUT outText             Text     , -- Текст сообщения
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFullInvent Boolean;
   DECLARE vbObjectId Integer;

   DECLARE vbText  Text;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);
    
    outShowMessage := False;
        
    IF TRIM(COALESCE(inBarCode, '')) = ''
    THEN
       RETURN;
    END IF;

    inBarCode := TRIM(COALESCE(inBarCode, ''));

    --определяем подразделение и дату документа
    SELECT DATE_TRUNC ('DAY', Movement.OperDate)
         , MLO_Unit.ObjectId
         , COALESCE (MovementBoolean_FullInvent.ValueData, False)
    INTO vbOperDate, vbUnitId, vbFullInvent
    FROM Movement
        INNER JOIN MovementLinkObject AS MLO_Unit
                                      ON MLO_Unit.MovementId = Movement.Id
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                        ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                       AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
    WHERE Movement.Id = inMovementId;
    
    IF vbFullInvent = False
    THEN
       RETURN;
    END IF;
       
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
      RETURN;
    END IF;
    
    IF EXISTS (SELECT 1
               FROM MovementItem AS MI
               WHERE MI.MovementId = inMovementId 
                  AND MI.DescId = zc_MI_Master() 
                  AND MI.ObjectId = vbGoodsId 
                  AND MI.isErased = FALSE)
    THEN
      RETURN;
    END IF;

    IF NOT EXISTS (SELECT 1
                   FROM Movement

                         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                      AND MovementLinkObject_Unit.DescId in (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                                                      AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                                      
                         INNER JOIN MovementItem AS MI ON MI.MovementId = Movement.Id 
                                                AND MI.DescId = zc_MI_Master() 
                                                AND MI.ObjectId = vbGoodsId 
                                                AND MI.isErased = FALSE
                                                
                         INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                    ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                   AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                   AND MovementBoolean_Deferred.ValueData = TRUE

                   WHERE Movement.DescId = zc_Movement_ReturnOut()
                     AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
      RETURN;
    END IF;

    outShowMessage := True;
    outPUSHType := zc_TypePUSH_Information();
    outText := 'Позиция отложена в документе Возврат поставщику. Просьба проверить и подготовить товар для возврата.';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.11.16                                                       *
*/

-- тест

select * from gpSelect_MovementItem_PUSH_InventBarcode(inMovementID := 25180682 , inBarCode := '4820196960058' ,  inSession := '3');