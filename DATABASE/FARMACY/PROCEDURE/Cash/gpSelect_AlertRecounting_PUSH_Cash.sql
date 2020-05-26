-- Function: gpSelect_AlertRecounting_PUSH_Cash()

DROP FUNCTION IF EXISTS gpSelect_AlertRecounting_PUSH_Cash (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_AlertRecounting_PUSH_Cash(
    IN inMovementID            Integer    , -- Movement PUSH
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
   DECLARE vbId         Integer;
   DECLARE vbText       Text;
BEGIN

  IF COALESCE((SELECT ObjectBoolean_Unit_AlertRecounting.ValueData
               FROM ObjectBoolean AS ObjectBoolean_Unit_AlertRecounting
               WHERE ObjectBoolean_Unit_AlertRecounting.ObjectId = inUnitID
                 AND ObjectBoolean_Unit_AlertRecounting.DescId = zc_ObjectBoolean_Unit_AlertRecounting()), False) = False
--     OR inUserId <> 3
  THEN
    RETURN;
  END IF;

  SELECT string_agg('Номер '||CASE WHEN Movement.DescId = zc_Movement_ReturnOut() THEN 'возврата поставщику' ELSE 'перемещения' END||' '
                            ||Movement.InvNumber||' дата '||TO_CHAR (Movement.OperDate, 'dd.mm.yyyy'), CHR(13) ORDER BY Movement.OperDate)
  INTO vbText
  FROM Movement

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId in (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                                    AND MovementLinkObject_Unit.ObjectId = inUnitID

  WHERE Movement.DescId in (zc_Movement_ReturnOut(), zc_Movement_Send())
    AND Movement.StatusId = zc_Enum_Status_UnComplete();

  IF COALESCE(vbText, '') <> ''
  THEN
      RETURN QUERY
      SELECT ('Коллеги, в ближайшие выходные у вас пройдет полный переучет, поэтому в обязательном порядке, эти документы должны быть проведены (список ниже)!!!'||CHR(13)||
             'Документы же, в которых вы указаны как отправитель должны быть проведены получателем либо вами отлолены!!!'||CHR(13)||
             'Вот этот список:'||CHR(13)||vbText||CHR(13)||
             'В случае невыполнения этих требований, на подразделение будет наложен штраф, сумму штрафа вам сообщат отдельно!')::TBlob,
             Null::TVarChar,
             Null::TVarChar,
             Null::TVarChar,
             Null::TVarChar,
             Null::TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 13.04.20         *
*/

-- SELECT * FROM gpSelect_AlertRecounting_PUSH_Cash(183292 , 3);