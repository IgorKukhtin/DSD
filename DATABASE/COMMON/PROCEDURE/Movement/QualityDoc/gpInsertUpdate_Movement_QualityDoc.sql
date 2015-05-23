-- Function: gpInsertUpdate_Movement_QualityDoc (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityDoc (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_QualityDoc(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Sale     Integer   , -- 
    IN inOperDateIn          TDateTime , -- Дата 
    IN inOperDateOut         TDateTime , -- Дата 
    IN inCarId               Integer   , -- Автомобиль
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_QualityDoc());


     -- параметр из документа - !!!временно!!!
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Sale);

     -- таблица - по 
     CREATE TEMP TABLE _tmpMovement_QualityDoc (MovementId Integer, MovementId_master Integer, MovementId_child Integer) ON COMMIT DROP;

       WITH -- элементы документа inMovementId_Sale
            tmpMI AS (SELECT MovementItem.*
                      FROM MovementItem
                           INNER JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                       AND MIFloat_Price.ValueData <> 0
                           INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                       AND MIFloat_AmountPartner.ValueData <> 0
                      WHERE MovementItem.MovementId =  inMovementId_Sale
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )
            -- получили список Goods
          , tmpMIGoods AS (SELECT DISTINCT tmpMI.ObjectId AS GoodsId FROM tmpMI)
            -- получили список Quality
          , tmpQuality AS (SELECT ObjectLink_GoodsQuality_Quality.ChildObjectId AS QualityId
                           FROM tmpMIGoods
                                INNER JOIN ObjectLink AS ObjectLink_GoodsQuality_Goods
                                                      ON ObjectLink_GoodsQuality_Goods.ChildObjectId = tmpMIGoods.GoodsId
                                                     AND ObjectLink_GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_GoodsQuality_Quality
                                                     ON ObjectLink_GoodsQuality_Quality.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                    AND ObjectLink_GoodsQuality_Quality.DescId = zc_ObjectLink_GoodsQuality_Quality()
                                INNER JOIN ObjectFloat AS ObjectFloat_Quality_NumberPrint
                                                       ON ObjectFloat_Quality_NumberPrint.ObjectId = ObjectLink_GoodsQuality_Quality.ChildObjectId
                                                      AND ObjectFloat_Quality_NumberPrint.DescId = zc_ObjectFloat_Quality_NumberPrint()
                                                      AND ObjectFloat_Quality_NumberPrint.ValueData = 1 -- !!!так захардкодил!!!, вообще их пока 2: вторая для консервов, первая все остальное
                           GROUP BY ObjectLink_GoodsQuality_Quality.ChildObjectId
                          )

            -- получили список всех zc_Movement_QualityParams для каждого Quality !!!с датой <= vbOperDate!!!
          , tmpMovementQualityParams_list AS (SELECT tmpQuality.QualityId, Movement.Id AS MovementId, Movement.OperDate
                                              FROM tmpQuality
                                                   INNER JOIN MovementLinkObject AS MLO_Quality
                                                                                 ON MLO_Quality.ObjectId = tmpQuality.QualityId
                                                                                AND MLO_Quality.DescId = zc_MovementLinkObject_Quality()
                                                   INNER JOIN Movement ON Movement.Id = MLO_Quality.MovementId
                                                                      AND Movement.DescId = zc_Movement_QualityParams()
                                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                      AND Movement.OperDate <= vbOperDate
                                             )
            -- для каждого Quality выбрали с MAX (OperDate) !!!это и будет последний!!!, кстати к этим док-там и должен быть привязан inMovementId_Sale
          , tmpMovementQualityParams_max AS (SELECT tmp.QualityId, MAX (tmpMovementQualityParams_list.MovementId) AS MovementId
                                             FROM (SELECT tmpMovementQualityParams_list.QualityId, MAX (tmpMovementQualityParams_list.OperDate) AS OperDate FROM tmpMovementQualityParams_list GROUP BY tmpMovementQualityParams_list.QualityId) AS tmp
                                                  INNER JOIN tmpMovementQualityParams_list ON tmpMovementQualityParams_list.QualityId = tmp.QualityId
                                                                                          AND tmpMovementQualityParams_list.OperDate = tmp.OperDate
                                             GROUP BY tmp.QualityId
                                            )
            -- документ inMovementId_Sale разложенный на !!!все!!! существующие MovementId + MovementId_master
          , tmpMovementQualityDoc AS (SELECT MovementLinkMovement_Child.MovementId       AS MovementId
                                           , MovementLinkMovement_Master.MovementChildId AS MovementId_master
                                      FROM Movement
                                           LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                                          ON MovementLinkMovement_Child.MovementChildId = Movement.Id 
                                                                         AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                                           LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                                          ON MovementLinkMovement_Master.MovementId = MovementLinkMovement_Child.MovementId
                                                                         AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                                           LEFT JOIN Movement AS Movement_QualityDoc ON Movement_QualityDoc.Id = MovementLinkMovement_Child.MovementId
                                      WHERE Movement.Id = inMovementId_Sale
                                     )
     -- получили "ненужный" список 
     INSERT INTO _tmpMovement_QualityDoc (MovementId)
        SELECT CASE WHEN tmpResult.MovementId_master <> 0
                         THEN lpInsertUpdate_Movement_QualityDoc (ioId               := tmpResult.MovementId
                                                                , inMovementId_master:= tmpResult.MovementId_master
                                                                , inMovementId_child := inMovementId_Sale
                                                                , inOperDateIn       := inOperDateIn
                                                                , inOperDateOut      := inOperDateOut
                                                                , inCarId            := inCarId
                                                                , inUserId           := vbUserId
                                                                 )
                    WHEN tmpResult.MovementId <> 0
                         THEN lpSetErased_Movement_QualityDoc (inMovementId := tmpResult.MovementId
                                                             , inUserId     := vbUserId
                                                              )
                    ELSE 0
               END
        FROM (SELECT COALESCE (tmpMovementQualityDoc.MovementId, 0)        AS MovementId         -- если не был выписан MovementId то будем создавать, иначе его Update or Delete
                   , COALESCE (tmpMovementQualityParams_max.MovementId, 0) AS MovementId_master  -- если 0 то создавать его не надо или надо удалить
               FROM tmpMovementQualityDoc
                    FULL JOIN tmpMovementQualityParams_max ON tmpMovementQualityParams_max.MovementId = tmpMovementQualityDoc.MovementId_master
             ) AS tmpResult
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_QualityDoc (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
