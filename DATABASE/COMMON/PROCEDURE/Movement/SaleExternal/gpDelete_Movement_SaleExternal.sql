-- Function: gpDelete_Movement_SaleExternal()

DROP FUNCTION IF EXISTS gpDelete_Movement_SaleExternal (TDateTime, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpDelete_Movement_SaleExternal(
    IN inOperDate              TDateTime , --
    IN inRetailId              Integer   , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_SaleExternal());

     -- проверка
   --IF vbUserId = 5
   --THEN
   --    RETURN;
   --END IF;

     -- проверка
     IF COALESCE (inRetailId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Торговая сеть не выбрана';
     END IF;

     PERFORM lpSetErased_Movement (inMovementId := Movement.Id, inUserId := vbUserId)
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                        ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                       AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
          INNER JOIN (SELECT DISTINCT COALESCE (ObjectLink_Partner_GoodsProperty.ChildObjectId
                           , COALESCE (ObjectLink_Contract_GoodsProperty.ChildObjectId
                           , COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId
                           , COALESCE (ObjectLink_Retail_GoodsProperty.ChildObjectId)))) AS GoodsPropertyId
                      FROM 
                          (SELECT ObjectLink_Juridical_Retail.ObjectId AS JuridicalId
                                , ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                                , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                           FROM ObjectLink AS ObjectLink_Juridical_Retail
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                    AND ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                     ON ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                    AND ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                           WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                           AND ObjectLink_Juridical_Retail.ChildObjectId = inRetailId --310854
                           ) AS tmp
                             LEFT JOIN ObjectLink AS ObjectLink_Partner_GoodsProperty
                                                  ON ObjectLink_Partner_GoodsProperty.ObjectId = tmp.PartnerId
                                                 AND ObjectLink_Partner_GoodsProperty.DescId = zc_ObjectLink_Partner_GoodsProperty()
                             LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                  ON ObjectLink_Juridical_GoodsProperty.ObjectId = tmp.JuridicalId
                                                 AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                                                  ON ObjectLink_Contract_GoodsProperty.ObjectId = tmp.ContractId
                                                 AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
                             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId = tmp.JuridicalId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                             LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                                                  ON ObjectLink_Retail_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                 AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
                      ) AS tmp ON tmp.GoodsPropertyId = MovementLinkObject_GoodsProperty.ObjectId
                      
     WHERE Movement.DescId = zc_Movement_SaleExternal()
       AND Movement.StatusId <> zc_Enum_Status_Erased()
       AND Movement.OperDate =  DATE_TRUNC ('MONTH', inOperDate)
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.11.20          *
*/

-- тест
--