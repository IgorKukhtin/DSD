-- Function: gpInsertUpdate_Movement_QualityDoc (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityDoc (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityDoc (Integer, Integer, TDateTime, TDateTime, Integer, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_QualityDoc(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Sale     Integer   , -- 
    IN inOperDateIn          TDateTime , -- Дата 
    IN inOperDateOut         TDateTime , -- Дата 
    IN inCarId               Integer   , -- Автомобиль
    IN inQualityNumber              TVarChar  , --
    IN inCertificateNumber          TVarChar  , --
    IN inOperDateCertificate        TDateTime , --
    IN inCertificateSeries          TVarChar  , --
    IN inCertificateSeriesNumber    TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_QualityDoc());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметр из документа - !!!временно!!!
     vbOperDate := (SELECT COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
                    FROM Movement
                         LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                               AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                    WHERE Movement.Id = inMovementId_Sale);

     -- таблица - по 
     CREATE TEMP TABLE _tmpMovement_QualityDoc (MovementId Integer, MovementId_master Integer, MovementId_child Integer) ON COMMIT DROP;

       WITH -- элементы документа inMovementId_Sale
            tmpMI AS (SELECT MovementItem.*
                      FROM MovementItem
                           INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                           INNER JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                       AND MIFloat_Price.ValueData <> 0
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      WHERE MovementItem.MovementId =  inMovementId_Sale
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND ((MIFloat_AmountPartner.ValueData <> 0 AND Movement.DescId <> zc_Movement_SendOnPrice())
                          OR (MovementItem.Amount <> 0 AND Movement.DescId = zc_Movement_SendOnPrice())
                            )
                     )
            -- получили список Goods
          , tmpMIGoods AS (SELECT DISTINCT tmpMI.ObjectId AS GoodsId FROM tmpMI)
            -- получили список Quality
          , tmpQuality AS (SELECT DISTINCT ObjectLink_GoodsQuality_Quality.ChildObjectId AS QualityId
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
                                                      AND ObjectFloat_Quality_NumberPrint.ValueData IN (1, 2, 3, 4) -- !!!так захардкодил!!!, вообще их пока 2: вторая для консервов, первая все остальное
                          )
             -- получили список Retail для inMovementId_Sale
           , tmpRetail AS (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                           FROM MovementLinkObject AS MovementLinkObject_To
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                     ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                           WHERE MovementLinkObject_To.MovementId = inMovementId_Sale
                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                          )

             -- получили список всех zc_Movement_QualityParams для каждого Quality !!!с датой <= vbOperDate!!!
           , tmpMovementQualityParams_all AS (SELECT tmpQuality.QualityId, Movement.Id AS MovementId, Movement.OperDate, COALESCE (MovementLinkObject_Retail.ObjectId, 0) AS RetailId
                                              FROM tmpQuality
                                                   INNER JOIN MovementLinkObject AS MLO_Quality
                                                                                 ON MLO_Quality.ObjectId = tmpQuality.QualityId
                                                                                AND MLO_Quality.DescId = zc_MovementLinkObject_Quality()
                                                   INNER JOIN Movement ON Movement.Id = MLO_Quality.MovementId
                                                                      AND Movement.DescId = zc_Movement_QualityParams()
                                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                      AND Movement.OperDate <= vbOperDate
                                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                                                ON MovementLinkObject_Retail.MovementId = MLO_Quality.MovementId
                                                                               AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                             )
            -- получили список всех zc_Movement_QualityParams для каждого Quality !!!+ условие по RetailId!!!
          , tmpMovementQualityParams_list AS (SELECT tmpQuality.QualityId
                                                   , COALESCE (tmpMovementQualityParams_all.MovementId, tmpMovementQualityParams_all_two.MovementId) AS MovementId
                                                   , COALESCE (tmpMovementQualityParams_all.OperDate, tmpMovementQualityParams_all_two.OperDate)     AS OperDate
                                              FROM tmpQuality
                                                   LEFT JOIN tmpRetail ON 1 = 0
                                                   LEFT JOIN tmpMovementQualityParams_all ON tmpMovementQualityParams_all.QualityId = tmpQuality.QualityId
                                                                                         AND tmpMovementQualityParams_all.RetailId = tmpRetail.RetailId
                                                   LEFT JOIN tmpMovementQualityParams_all AS tmpMovementQualityParams_all_two
                                                                                         ON tmpMovementQualityParams_all_two.QualityId = tmpQuality.QualityId
                                                                                        AND tmpMovementQualityParams_all_two.RetailId = 0
                                                                                        AND tmpMovementQualityParams_all.QualityId IS NULL
                                             )
            -- для каждого Quality выбрали с MAX (OperDate) !!!это и будет последний!!!, кстати к этим док-там и должен быть привязан inMovementId_Sale
          , tmpMovementQualityParams_max AS (SELECT tmp.QualityId, MAX (tmpMovementQualityParams_list.MovementId) AS MovementId
                                             FROM (SELECT tmpMovementQualityParams_list.QualityId
                                                        , MAX (tmpMovementQualityParams_list.OperDate) AS OperDate
                                                   FROM tmpMovementQualityParams_list
                                                   GROUP BY tmpMovementQualityParams_list.QualityId
                                                  ) AS tmp
                                                  INNER JOIN tmpMovementQualityParams_list ON tmpMovementQualityParams_list.QualityId = tmp.QualityId
                                                                                          AND tmpMovementQualityParams_list.OperDate  = tmp.OperDate
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
                         THEN lpInsertUpdate_Movement_QualityDoc (ioId                     := tmpResult.MovementId
                                                                , inMovementId_master      := tmpResult.MovementId_master
                                                                , inMovementId_child       := inMovementId_Sale
                                                                , inOperDateIn             := inOperDateIn
                                                                , inOperDateOut            := inOperDateOut
                                                                , inCarId                  := inCarId
                                                                , inQualityNumber          := inQualityNumber
                                                                , inCertificateNumber      := inCertificateNumber
                                                                , inOperDateCertificate    := inOperDateCertificate
                                                                , inCertificateSeries      := inCertificateSeries
                                                                , inCertificateSeriesNumber:= inCertificateSeriesNumber
                                                                , inUserId                 := vbUserId
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
 26.05.15         * 
 22.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_QualityDoc (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
