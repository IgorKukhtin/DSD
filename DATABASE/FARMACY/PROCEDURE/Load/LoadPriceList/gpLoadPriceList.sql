-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadPriceList(
    IN inId                  Integer   , -- Прайс-лист
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);

     -- Получаем параметры прайсЛиста
     SELECT 
           LoadPriceList.OperDate	 
         , LoadPriceList.JuridicalId 
         , LoadPriceList.ContractId INTO vbOperDate, vbJuridicalId, vbContractId
      FROM LoadPriceList WHERE LoadPriceList.Id = inId;

     UPDATE LoadPriceList SET isMoved = true WHERE Id = inId;

     -- Если прайс за этот день, юрлицу и договору не найден, то добавляем. А если найден, то сохраняем ИД
     SELECT
            Movement.Id INTO vbPriceListId
       FROM Movement 
            JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                    ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                   AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            JOIN MovementLinkObject AS MovementLinkObject_Contract
                                    ON MovementLinkObject_Contract.MovementId = Movement.Id
                                   AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
      WHERE Movement.OperDate = vbOperDate AND Movement.DescId = zc_Movement_PriceList()
        AND MovementLinkObject_Juridical.ObjectId = vbJuridicalId AND COALESCE(MovementLinkObject_Contract.ObjectId, 0) = vbContractId;

      IF COALESCE(vbPriceListId, 0) = 0 THEN 
         vbPriceListId := gpInsertUpdate_Movement_PriceList(0, '', vbOperDate, vbJuridicalId, vbContractId, inSession);
      END IF;

     -- Перенос элементов прайса
     PERFORM gpInsertUpdate_MovementItem_PriceList(
                      0 , -- Ключ объекта <Элемент документа>
          vbPriceListId , -- Ключ объекта <Документ>
                GoodsId , -- Товары
        Object_Goods.Id , -- Товар прайс-листа
           CASE LoadPriceList.NDSinPrice 
                 WHEN True THEN Price 
                 ELSE Price * (100 + ObjectFloat_NDSKind_NDS.ValueData) / 100 
           END:: TFloat  , -- Цена
          ExpirationDate , -- Партия товара
              inSession )
       FROM LoadPriceListItem 
               JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = LoadPriceListItem.GoodsId
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
               
          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.Childobjectid
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   

               JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode
                                FROM Object_Goods_View 
                               WHERE ObjectId = vbJuridicalId
                    ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
      WHERE GoodsId <> 0 AND LoadPriceListId = inId
        AND (GoodsId, Object_Goods.Id)  
             NOT IN (SELECT MovementItem.ObjectId, MILinkObject_Goods.ObjectId FROM MovementItem 
                       JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                      WHERE MovementId = vbPriceListId);


     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.10.14                        *  
 18.09.14                        *  
 10.09.14                        *  
*/

-- тест
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
