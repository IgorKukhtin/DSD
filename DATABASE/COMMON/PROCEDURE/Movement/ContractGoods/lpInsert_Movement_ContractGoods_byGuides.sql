-- Function: lpInsert_Movement_ContractGoods_byGuides()

DROP FUNCTION IF EXISTS lpInsert_Movement_ContractGoods_byGuides (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_ContractGoods_byGuides(
    IN inStartDate           TDateTime , -- Дата документа
    IN inEndDate             TDateTime , -- Дата документа
    IN inContractId          Integer   , -- 
    IN inJuridicalId         Integer   , --
    IN inGoodsId             Integer   , --
    IN inGoodsKindId         Integer   , --
    IN inPrice               TFloat    , --
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbId Integer;
BEGIN
     -- пробуем найти сохраненный документ
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                        AND MovementLinkObject_Contract.ObjectId = inContractId
                           INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                 ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                                                AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                AND ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId
                           INNER JOIN MovementDate AS MovementDate_EndBegin
                                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()
                                                  AND MovementDate_EndBegin.ValueData = inEndDate
                      WHERE Movement.DescId = zc_Movement_ContractGoods()
                        AND Movement.OperDate = inStartDate
                        AND Movement.StatusId <> zc_Enum_Status_Erased());

      --если не нашли документ записываем новый
      IF COALESCE (vbMovementId,0) = 0
      THEN
          -- сохраняем докеумент
          SELECT tmp.ioId
        INTO vbMovementId 
          FROM lpInsertUpdate_Movement_ContractGoods (ioId           := COALESCE (vbMovementId,0)
                                                    , ioInvNumber    := (SELECT tmp.InvNumber FROM gpGet_Movement_ContractGoods (COALESCE (vbMovementId,0), inStartDate, inUserId::TVarChar) AS tmp)
                                                    , inOperDate     := inStartDate
                                                    , inEndBeginDate := inEndDate
                                                    , inContractId   := inContractId
                                                    , inComment      := 'загрузка'
                                                    , inUserId       := inUserId
                                                     ) AS tmp;
      END IF;

 
      -- пробуем найти строку
      vbId := (SELECT MovementItem.Id
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = vbMovementId
                 AND MovementItem.ObjectId = inGoodsId
                 AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE (inGoodsKindId,0)
               );

      -- записываем строки PromoGoods документа
      PERFORM lpInsertUpdate_MovementItem_ContractGoods (ioId           := COALESCE (vbId,0)
                                                       , inMovementId   := vbMovementId
                                                       , inGoodsId      := inGoodsId
                                                       , inGoodsKindId  := inGoodsKindId
                                                       , inisBonusNo    := FALSE
                                                       , inPrice        := inPrice 
                                                       , inChangePrice   := 0 ::TFloat
                                                       , inChangePercent := 0 ::TFloat
                                                       , inCountForAmount:= 1 ::TFloat
                                                       , inComment      := '' ::TVarChar
                                                       , inUserId       := inUserId
                                                        ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  26.08.21        *
*/

-- тест
--


/*
SELECT lpInsert_Movement_ContractGoods_byGuides (inStartDate   := tmp.StartDate ::TDateTime
                                               , inEndDate     := tmp.EndDate
                                               , inContractId  := tmp.ContractId
                                               , inJuridicalId := tmp.JuridicalId
                                               , inGoodsId     := tmp.GoodsId
                                               , inGoodsKindId := tmp.GoodsKindId
                                               , inPrice       := tmp.Price
                                               , inUserId      := 5
                                                )
FROM (
SELECT ContractGoods_Contract.ChildObjectId             AS ContractId
                , ObjectLink_Contract_Juridical.ChildObjectId      AS JuridicalId
                , ObjectLink_ContractGoods_Goods.ChildObjectId     AS GoodsId
                , ObjectLink_ContractGoods_GoodsKind.ChildObjectId AS GoodsKindId
                , ObjectDate_Start.ValueData          ::TDateTime  AS StartDate
                , ObjectDate_End.ValueData            ::TDateTime  AS EndDate
                , ObjectFloat_Price.ValueData                      AS Price
                , MAX (ObjectDate_End.ValueData) OVER (PARTITION BY ContractGoods_Contract.ChildObjectId, ObjectLink_ContractGoods_Goods.ChildObjectId, ObjectLink_ContractGoods_GoodsKind.ChildObjectId) AS EndDate_last
           FROM Object AS Object_ContractGoods
                INNER JOIN ObjectLink AS ContractGoods_Contract
                                     ON ContractGoods_Contract.ObjectId = Object_ContractGoods.Id
                                    AND ContractGoods_Contract.DescId = zc_ObjectLink_ContractGoods_Contract()
                                    AND ContractGoods_Contract.ChildObjectId = 5755919
 
                LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                     ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                    AND ObjectLink_ContractGoods_Goods.DescId = zc_ObjectLink_ContractGoods_Goods()
  
                LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_GoodsKind
                                     ON ObjectLink_ContractGoods_GoodsKind.ObjectId = Object_ContractGoods.Id
                                    AND ObjectLink_ContractGoods_GoodsKind.DescId = zc_ObjectLink_ContractGoods_GoodsKind()
  
                LEFT JOIN ObjectDate AS ObjectDate_Start
                                     ON ObjectDate_Start.ObjectId = Object_ContractGoods.Id
                                    AND ObjectDate_Start.DescId = zc_ObjectDate_ContractGoods_Start()
                LEFT JOIN ObjectDate AS ObjectDate_End
                                     ON ObjectDate_End.ObjectId = Object_ContractGoods.Id
                                    AND ObjectDate_End.DescId = zc_ObjectDate_ContractGoods_End()
  
                LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                      ON ObjectFloat_Price.ObjectId = Object_ContractGoods.Id 
                                     AND ObjectFloat_Price.DescId = zc_ObjectFloat_ContractGoods_Price()

                LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                     ON ObjectLink_Contract_Juridical.ObjectId = ContractGoods_Contract.ChildObjectId
                                    AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

           WHERE Object_ContractGoods.DescId = zc_Object_ContractGoods()
             AND (Object_ContractGoods.isErased = FALSE )
) AS tmp
     WHERE tmp.EndDate = tmp.EndDate_last


*/


/*

++UPDATE MovementItem SET isErased = TRUE WHERE Id in (
 WITH 
           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                          , MovementItem.Amount                           AS Amount
                          , MovementItem.ObjectId                         AS GoodsId
, tmpMov.OperDate, tmpMov.InvNumber
                     FROM (SELECT Movement.* From Movement WHERE Movement.DescId = zc_Movement_ContractGoods() and Movement.StatusId <> zc_Enum_Status_Erased() and Movement.OperDate = '02.10.2020') AS tmpMov
                          INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                     )

     , tmpMI_Float AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                          AND MovementItemFloat.DescId IN (zc_MIFloat_Price())
                          )

SELECT tmpMI.MovementItemId
  FROM tmpMI
            LEFT JOIN tmpMI_Float AS MIFloat_Price
                                  ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
WHERE COALESCE (MIFloat_Price.ValueData,0) = 0
)

*/