-- Function: gpGet_Scale_OperDatePartner (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Scale_OperDatePartner (Integer, Integer, Integer, Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_OperDatePartner (Integer, Integer, Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_OperDatePartner(
    IN inBranchCode          Integer   , --
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementDescId      Integer   , --
    IN inToId                Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inIsDocInsert         Boolean   , -- 
    IN inIsOldPeriod         Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDatePartner    TDateTime
             , isDialog           Boolean
             , MovementId_find    Integer
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbBranchId Integer;

   DECLARE vbMovementId_find Integer;

   DECLARE vbOperDatePartner_order TDateTime;
   DECLARE vbOperDate_order        TDateTime;
   DECLARE vbOperDatePartner       TDateTime;

   DECLARE vbIsDocMany Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     IF inMovementDescId = zc_Movement_Sale()
     THEN

         -- определили
         vbRetailId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                       FROM ObjectLink AS ObjectLink_Partner_Juridical
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                       WHERE ObjectLink_Partner_Juridical.ObjectId = inToId
                         AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                      );
         -- определяется - может ли быть несколько документов под одну заявку
         vbIsDocMany:= inBranchCode = 1 AND vbRetailId IN (310839 -- Фора
                                                         , 310854 -- Фоззі
                                                         , 310846 -- ВК
                                                         , vbRetailId
                                                          );

         -- определили
         vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                           ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                      END;

         -- определяется признак
         inIsDocInsert:= inIsDocInsert = TRUE AND vbIsDocMany = TRUE;

         -- !!!определяется OperDate заявки, !!!иначе inOperDate!!!
         vbOperDate_order:= COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.DescId = zc_Movement_OrderExternal() AND Movement.Id = (SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order WHERE MLM_Order.MovementId = inMovementId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()))
                                    , inOperDate);

         -- !!!определяется расчетная дата склад из заявки, !!!иначе inOperDate!!!
         vbOperDatePartner_order:= COALESCE ((SELECT MovementDate.ValueData
                                              FROM MovementDate JOIN Movement ON Movement.Id = MovementDate.MovementId AND Movement.DescId = zc_Movement_OrderExternal()
                                              WHERE MovementDate.DescId = zc_MovementDate_OperDatePartner()
                                                AND MovementDate.MovementId = (SELECT MLM_Order.MovementChildId
                                                                               FROM MovementLinkMovement AS MLM_Order
                                                                               WHERE MLM_Order.MovementId = inMovementId
                                                                                 AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                                                              )
                                             )
                                           , inOperDate);
         -- !!!если по заявке, тогда берется из неё OperDatePartner, вообще - надо только для филиалов!!!
         inOperDate:= CASE WHEN vbBranchId   = zc_Branch_Basis()
                             -- AND inSession <> '5'
                             AND EXISTS (SELECT 1
                                         FROM MovementLinkMovement
                                              INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                              ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                             AND MovementLinkMovement_Order.DescId          = zc_MovementLinkMovement_Order()
                                              INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Order.MovementId
                                                                 AND Movement.DescId   = zc_Movement_Sale()
                                                                 AND Movement.OperDate = inOperDate - INTERVAL '1 DAY'
                                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                         WHERE MovementLinkMovement.MovementId = inMovementId
                                           AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Order()
                                        )
                                THEN inOperDate - INTERVAL '1 DAY' -- !!!сдвигаем на 1 день, т.к. НЕ успели закрыть до 8:00!!!

                           -- так для Киев и Днепр - т.е. ничего не меняется, дата по факту
                           WHEN vbBranchId   = zc_Branch_Basis()
                             OR inBranchCode = 2 -- филиал Киев
                                THEN inOperDate

                         --WHEN inIsOldPeriod = FALSE
                         --     THEN inOperDate

                           ELSE vbOperDatePartner_order
                      END;

         -- поиск Документа
         IF inMovementDescId = zc_Movement_Sale() AND inIsDocInsert = FALSE
         THEN
              -- проверка для 
              IF vbIsDocMany = FALSE
                 AND 1 < (SELECT COUNT(*) FROM MovementLinkMovement
                                         INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                         ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                        AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                         INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                            AND Movement.DescId = zc_Movement_Sale()
                                                          --AND Movement.OperDate = inOperDate
                                                            AND Movement.OperDate BETWEEN inOperDate - CASE WHEN inIsOldPeriod = TRUE THEN '2 DAY' ELSE '0 DAY' END :: INTERVAL AND inOperDate
                                                            AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                    WHERE MovementLinkMovement.MovementId = inMovementId
                                      AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order())
              THEN
                  RAISE EXCEPTION 'Ошибка. Найдено несколько документов Продажа для заявки № <%>'
                                 , (SELECT Movement.InvNumber
                                    FROM MovementLinkMovement
                                         INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                    WHERE MovementLinkMovement.MovementId = inMovementId
                                      AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                    LIMIT 1
                                   );
              END IF;
              -- поиск существующего документа <Продажа покупателю> по Заявке
              vbMovementId_find:= (SELECT Movement.Id
                                    FROM MovementLinkMovement
                                         INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                         ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                        AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                         INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                            AND Movement.DescId = zc_Movement_Sale()
                                                          --AND Movement.OperDate = inOperDate
                                                            AND Movement.OperDate BETWEEN inOperDate - CASE WHEN inIsOldPeriod = TRUE THEN '2 DAY' ELSE '0 DAY' END :: INTERVAL AND inOperDate
                                                            AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                    WHERE MovementLinkMovement.MovementId = inMovementId
                                      AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                      -- AND inSession <> '5'
                                    ORDER BY Movement.Id DESC
                                    LIMIT CASE WHEN vbIsDocMany = TRUE THEN 1 ELSE 100 END
                                  );
         END IF;
         
         IF vbMovementId_find > 0 
         THEN
             vbOperDatePartner:= (SELECT COALESCE (MovementDate.ValueData, Movement.OperDate)
                                  FROM Movement
                                       LEFT JOIN MovementDate ON MovementDate.MovementId = Movement.Id
                                                             AND MovementDate.DescId     = zc_MovementDate_OperDatePartner()
                                  WHERE Movement.Id = vbMovementId_find
                                 );
         ELSE
             vbOperDatePartner:= -- !!!если по заявке, тогда расчет OperDatePartner от OperDate заявки - надо только для inBranchCode = 201 + 2
                                 (CASE WHEN inBranchCode = 2 OR inBranchCode BETWEEN 201 AND 210 THEN vbOperDate_order ELSE inOperDate END
                               + (CASE WHEN inBranchCode = 2 OR inBranchCode BETWEEN 201 AND 210 THEN COALESCE ((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inToId AND OFl.DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: Integer ELSE 0 END :: TVarChar || ' DAY') :: INTERVAL
                               + (COALESCE ((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inToId AND OFl.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime
                                ;
         END IF;

     END IF;

    -- Результат
    RETURN QUERY
      SELECT CASE WHEN inMovementDescId = zc_Movement_Income() AND inBranchCode BETWEEN 201 AND 203
                   AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner())
                       THEN inOperDate
                  WHEN inMovementDescId = zc_Movement_Sale()   THEN vbOperDatePartner
                  ELSE inOperDate
             END :: TDateTime AS OperDatePartner

           , CASE WHEN inMovementDescId = zc_Movement_Income() AND inBranchCode BETWEEN 201 AND 203
                   AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner())
                       THEN TRUE
                  WHEN inMovementDescId = zc_Movement_Sale() THEN TRUE
                --WHEN inBranchCode IN (301, 302) AND inMovementDescId = zc_Movement_Income() THEN TRUE
                  ELSE FALSE
             END :: Boolean   AS isDialog
           , vbMovementId_find AS MovementId_find
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.06.15                                        * all
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_OperDatePartner (3, 25018463, zc_Movement_Sale(), (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = 25018463 AND DescId = zc_MovementLinkObject_To()), CURRENT_DATE, TRUE, FALSE, zfCalc_UserAdmin())
