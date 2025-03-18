-- Function: gpInsertUpdate_Movement_EDI()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIOrder (TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIOrder (TVarChar, TDateTime, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIOrder(
    IN inOrderInvNumber      TVarChar  , -- Номер документа
    IN inOrderOperDate       TDateTime , -- Дата документа
    IN inGLN                 TVarChar  , -- Код GLN - Покупатель
    IN inGLNPlace            TVarChar  , -- Код GLN - место доставки
    IN gIsDelete             Boolean   , -- виртуальный, что б в компоненте понимать - надо ли удалять заявки "за сегодня", а "за вчера" - они удаляются всегда
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, GoodsPropertyID Integer, isMetro Boolean, isLoad Boolean) -- Классификатор товаров)
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbMovementId Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbDescCode TVarChar;
   DECLARE vbisLoad Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId:= lpGetUserBySession (inSession);

/*
if inSession <> '5' and 1=0
then
    RAISE EXCEPTION 'Error';
end if;
*/
     vbMovementId := NULL;


     -- Проверка
     IF vbUserId <> 5
    AND 1 < (SELECT COUNT (*)
             FROM Movement
                  INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                            ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                           AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                           AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
             WHERE Movement.DescId = zc_Movement_EDI()
               AND Movement.OperDate = inOrderOperDate
               AND Movement.InvNumber = inOrderInvNumber
               AND Movement.StatusId <> zc_Enum_Status_Erased()
            )
     THEN
         -- попробуем исправить ... закомментил, т.к. не проверил как оно работает
         /**/
         UPDATE Movement SET StatusId = zc_Enum_Status_Erased()
         WHERE Movement.DescId = zc_Movement_EDI()
           AND Movement.OperDate = inOrderOperDate
           AND Movement.Id IN (SELECT tmp.Id
                               FROM
                                   (SELECT Movement.*
                                         , Movement_Order.Id AS MovementId_find
                                         , ROW_NUMBER() OVER (PARTITION BY MovementString_GLNPlaceCode.ValueData, Movement.InvNumber
                                                              ORDER BY CASE WHEN Movement_Order.Id > 0 THEN 1 ELSE 2 END) AS Ord
                                    FROM Movement
                                         INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                                   ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                                  AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                                  -- AND MovementString_GLNPlaceCode.ValueData = '4820141820833'
                                         LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                        ON MovementLinkMovement_Order.MovementChildId = Movement.Id
                                                                       AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                         LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementId
                                                                             -- AND Movement_Order.StatusId = zc_Enum_Status_Complete()
                                    WHERE Movement.DescId = zc_Movement_EDI()
                                      AND Movement.OperDate = inOrderOperDate
                                      -- AND Movement.InvNumber = '3369002860' -- '3147002592'
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    ) AS tmp
                               WHERE tmp.Ord <> 1
                                 AND tmp.MovementId_find IS NULL
                              );
        /**/
        -- Проверка после исправления
        IF 1 < (SELECT COUNT (*)
                FROM Movement
                     INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                               ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                              AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                              AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                WHERE Movement.DescId = zc_Movement_EDI()
                  AND Movement.OperDate = inOrderOperDate
                  AND Movement.InvNumber = inOrderInvNumber
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
               )
        THEN
            --
            RAISE EXCEPTION 'Ошибка.Документ EDI № <%> от <%> для точки доставки с GLN = <%> загружен больше 1 раза.', inOrderInvNumber, DATE (inOrderOperDate), inGLNPlace;
        END IF;

     END IF;


     -- Проверка
     IF 0 < (SELECT COUNT (*)
             FROM Movement
                  INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                            ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                           AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                           AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                  INNER JOIN MovementString AS MovementString_DealId
                                            ON MovementString_DealId.MovementId = Movement.Id
                                           AND MovementString_DealId.DescId     = zc_MovementString_DealId()
                                           AND MovementString_DealId.ValueData  <> ''
             WHERE Movement.DescId = zc_Movement_EDI()
               AND Movement.OperDate = inOrderOperDate
               AND Movement.InvNumber = inOrderInvNumber
               AND Movement.StatusId <> zc_Enum_Status_Erased()
            )
     THEN
         -- Выход т.к. документ уже загружен
         RETURN QUERY
            SELECT Movement.Id
                 , MLO_GoodsProperty.ObjectId AS GoodsPropertyID
                 , CASE WHEN MLO_GoodsProperty.ObjectId = 83954 -- Метро
                             THEN TRUE
                        ELSE FALSE
                   END :: Boolean AS isMetro
                 , TRUE       AS isLoad
            FROM Movement
                  INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                            ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                           AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                           AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                  INNER JOIN MovementString AS MovementString_DealId
                                            ON MovementString_DealId.MovementId = Movement.Id
                                           AND MovementString_DealId.DescId     = zc_MovementString_DealId()
                                           AND MovementString_DealId.ValueData  <> ''

                  LEFT JOIN MovementLinkObject AS MLO_GoodsProperty
                                               ON MLO_GoodsProperty.MovementId = Movement.Id
                                              AND MLO_GoodsProperty.DescId     = zc_MovementLinkObject_GoodsProperty()

            WHERE Movement.DescId = zc_Movement_EDI()
              AND Movement.OperDate = inOrderOperDate
              AND Movement.InvNumber = inOrderInvNumber
              AND Movement.StatusId <> zc_Enum_Status_Erased()
            LIMIT 1
           ;

         -- Выход
         RETURN;

     END IF;


     -- находим документ (по идее один товар - один GLN-код) + !!!по точке доставки!!!
     vbMovementId:= (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                    ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                   AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                   AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                     WHERE Movement.DescId = zc_Movement_EDI()
                       AND Movement.OperDate = inOrderOperDate
                       AND Movement.InvNumber = inOrderInvNumber
                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                     --AND vbUserId <> 5
                    );

     IF COALESCE(vbMovementId, 0) = 0 OR
        NOT EXISTS (SELECT 1 FROM MovementBoolean
                    WHERE MovementBoolean.MovementId = vbMovementId
                      AND MovementBoolean.DescId = zc_MovementBoolean_isLoad()
                      AND MovementBoolean.ValueData = TRUE)
     THEN

       -- определяется параметр
       vbDescCode:= (SELECT MovementDesc.Code FROM MovementDesc WHERE Id = zc_Movement_OrderExternal());
       IF vbDescCode IS NULL
       THEN
           RAISE EXCEPTION 'Ошибка в параметре.<%>', inDesc;
       END IF;


       -- если не нашли
       IF COALESCE (vbMovementId, 0) = 0
       THEN
           -- будем проверять на УНИКАЛЬНОСТЬ
           vbIsInsert:= TRUE;
           -- сохранили <Документ>
           vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
       ELSE
           vbIsInsert:= FALSE;
       END IF;

       -- сохранили
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, vbDescCode);

       IF inGLN <> '' THEN
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNCode(), vbMovementId, inGLN);
       END IF;

       IF inGLNPlace <> '' THEN
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), vbMovementId, inGLNPlace);
          -- Пытаемся установить связь с точкой доставки
          vbPartnerId := COALESCE((SELECT MIN (ObjectId)
                      FROM ObjectString WHERE DescId = zc_ObjectString_Partner_GLNCode() AND ValueData = inGLNPlace), 0);
          IF vbPartnerId <> 0 THEN
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbMovementId, vbPartnerId);
          END IF;
       END IF;


       IF vbPartnerId <> 0 THEN -- Находим Юр лицо по контрагенту
          vbJuridicalId := COALESCE((SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Partner_Juridical() AND ObjectId = vbPartnerId), 0);
       END IF;

       IF COALESCE (vbJuridicalId, 0) <> 0 THEN
          -- сохранили <Юр лицо>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementId, vbJuridicalId);

          -- сохранили <ОКПО>
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, (SELECT OKPO FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = vbJuridicalId));

          -- Поиск <Классификатор товаров>
          -- vbGoodsPropertyID := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);
          vbGoodsPropertyId := zfCalc_GoodsPropertyId ((SELECT MLO_Contract.ObjectId FROM MovementLinkObject AS MLO_Contract WHERE MLO_Contract.MovementId = vbMovementId AND MLO_Contract.DescId = zc_MovementLinkObject_Contract())
                                                     , vbJuridicalId
                                                     , vbPartnerId
                                                      );
          -- сохранили <Классификатор товаров>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), vbMovementId, vbGoodsPropertyId);

       END IF;


       -- теперь этот протокол будет в EXE
       -- PERFORM lpInsert_Movement_EDIEvents(vbMovementId, 'Загрузка ORDER из EDI', vbUserId);


       -- Проверка
       IF 1 < (SELECT COUNT (*)
               FROM Movement
                    INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                              ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                             AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                             AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
               WHERE Movement.DescId = zc_Movement_EDI()
                 AND Movement.OperDate = inOrderOperDate
                 AND Movement.InvNumber = inOrderInvNumber
                 AND Movement.StatusId <> zc_Enum_Status_Erased())
       THEN
           RAISE EXCEPTION 'Ошибка.Документ EDI № <%> от <%> для точки доставки с GLN = <%> загружен больше 1 раза. Повторите действие через 25 сек.', inOrderInvNumber, DATE (inOrderOperDate), inGLNPlace;
       END IF;


       -- Проверка через УНИКАЛЬНОСТЬ
       IF vbIsInsert = TRUE
       THEN
           PERFORM lpInsert_LockUnique (inKeyData:= 'Movement'
                                          || ';' || zc_Movement_EDI() :: TVarChar
                                          || ';' || inOrderInvNumber
                                          || ';' || zfConvert_DateToString (inOrderOperDate)
                                          || ';' || inGLNPlace
                                      , inUserId:= vbUserId);
       END IF;

       vbisLoad := False;
     ELSE

       vbGoodsPropertyId := (SELECT MovementLinkObject.ObjectId
                             FROM MovementLinkObject
                             WHERE MovementLinkObject.MovementId = vbMovementId
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_GoodsProperty());

       vbisLoad := True;
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, vbIsInsert);


IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.Test PartnerId = %', vbPartnerId;
END IF;

     RETURN QUERY
     SELECT vbMovementId
          , vbGoodsPropertyID
          , CASE WHEN vbGoodsPropertyID = 83954 -- Метро
                      THEN TRUE
                 ELSE FALSE
            END :: Boolean AS isMetro
          , vbisLoad       AS isLoad
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.14                         *

*/

-- тест
--
-- select * from gpInsertUpdate_Movement_EDIOrder(inOrderInvNumber := 'MAIДB007537' , inOrderOperDate := ('21.01.2021')::TDateTime , inGLN := '9864066853281' , inGLNPlace := '9864232336358' , gIsDelete := 'True' ,  inSession := '14610');
