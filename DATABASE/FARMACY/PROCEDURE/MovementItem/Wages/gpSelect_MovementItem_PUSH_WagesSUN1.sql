-- Function: gpSelect_MovementItem_PUSH_WagesSUN1()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PUSH_WagesSUN1 (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PUSH_WagesSUN1(
    IN inUnitID                Integer    , -- Подразделение
    IN inUserId                Integer      -- Сотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar)
AS
$BODY$
   DECLARE vbWeek       Integer;
   DECLARE vbOparDate   TDateTime;
   DECLARE vbSummaSUN1  TFloat;
   DECLARE vbSummaFact  TFloat;
   DECLARE vbMovementId Integer;
   DECLARE vbId         Integer;
BEGIN

  IF date_part('DOW', CURRENT_DATE)::Integer = 4
  THEN
    vbSummaSUN1 := - 200;
    vbOparDate := CURRENT_DATE;
  ELSEIF  date_part('DOW', CURRENT_DATE)::Integer = 5
  THEN
    vbSummaSUN1 := - 400;
    vbOparDate := CURRENT_DATE - INTERVAL '1 day';
  ELSEIF  date_part('DOW', CURRENT_DATE)::Integer = 1
  THEN
    vbSummaSUN1 := - 750;
    vbOparDate := CURRENT_DATE - INTERVAL '4 day';
  ELSE
    RETURN;
  END IF;

  IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = date_trunc('month', vbOparDate) AND Movement.DescId = zc_Movement_Wages())
  THEN
      SELECT Movement.ID
      INTO vbMovementId
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', vbOparDate)
        AND Movement.DescId = zc_Movement_Wages();
  ELSE
    RETURN;
  END IF;

  IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.DescId = zc_MI_Sign()
                                         AND MovementItem.MovementId = vbMovementId
                                         AND MovementItem.ObjectId = inUnitID)
  THEN
      SELECT MovementItem.id
      INTO vbId
      FROM MovementItem
      WHERE MovementItem.DescId = zc_MI_Sign()
        AND MovementItem.MovementId = vbMovementId
        AND MovementItem.ObjectId = inUnitID;
  ELSE
    RETURN;
  END IF;


  vbWeek := date_part('DAY', vbOparDate)::Integer / 7 + 1;

   -- сохранили свойство <По неделям>
  IF vbWeek = 1
  THEN
    vbSummaFact := COALESCE((SELECT ValueData FROM MovementItemFloat WHERE DescId = zc_MIFloat_SummaWeek1() AND MovementItemID = vbId), 0);
  ELSEIF vbWeek = 2
  THEN
    vbSummaFact := COALESCE((SELECT ValueData FROM MovementItemFloat WHERE DescId = zc_MIFloat_SummaWeek2() AND MovementItemID = vbId), 0);
  ELSEIF vbWeek = 3
  THEN
    vbSummaFact := COALESCE((SELECT ValueData FROM MovementItemFloat WHERE DescId = zc_MIFloat_SummaWeek3() AND MovementItemID = vbId), 0);
  ELSEIF vbWeek = 4
  THEN
    vbSummaFact := COALESCE((SELECT ValueData FROM MovementItemFloat WHERE DescId = zc_MIFloat_SummaWeek4() AND MovementItemID = vbId), 0);
  ELSEIF vbWeek = 5
  THEN
    vbSummaFact := COALESCE((SELECT ValueData FROM MovementItemFloat WHERE DescId = zc_MIFloat_SummaWeek5() AND MovementItemID = vbId), 0);
  ELSE
    RAISE EXCEPTION 'Ошибка.Определения номера дня %', vbWeek;
  END IF;

  IF date_part('DOW', CURRENT_DATE)::Integer = 4 AND vbSummaFact = vbSummaSUN1
  THEN
    RETURN QUERY
    SELECT 'Коллеги, вам начислен штраф в размере 200 грн за несвоевременный сбор СУН1'::TBlob,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           Null::TVarChar;
  ELSEIF  date_part('DOW', CURRENT_DATE)::Integer = 5 AND vbSummaFact = vbSummaSUN1
  THEN
    RETURN QUERY
    SELECT 'Коллеги, вам начислен штраф в размере 400 грн за несвоевременный сбор СУН1'::TBlob,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           Null::TVarChar;
  ELSEIF  date_part('DOW', CURRENT_DATE)::Integer = 1 AND vbSummaFact = vbSummaSUN1
  THEN
    RETURN QUERY
    SELECT 'Коллеги, вам начислен штраф в размере 750 грн за несвоевременный сбор СУН1'::TBlob,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           Null::TVarChar;
  ELSE
    RETURN;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 19.02.20         *
*/

-- SELECT * FROM gpSelect_MovementItem_PUSH_WagesSUN1(183292 , 3);