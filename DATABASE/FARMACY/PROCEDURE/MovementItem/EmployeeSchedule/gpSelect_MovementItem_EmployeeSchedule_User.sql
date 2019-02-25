-- Function: gpSelect_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeSchedule_User(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeSchedule_User(
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS TABLE (ID Integer,
                 Range TVarChar,
                 Value1 TVarChar,
                 Value2 TVarChar,
                 Value3 TVarChar,
                 Value4 TVarChar,
                 Value5 TVarChar,
                 Value6 TVarChar,
                 Value7 TVarChar,
                 ValuePlan1 TVarChar,
                 ValuePlan2 TVarChar,
                 ValuePlan3 TVarChar,
                 vValuePlan4 TVarChar,
                 ValuePlan5 TVarChar,
                 ValuePlan6 TVarChar,
                 vValuePlan7 TVarChar,
                 Color1 Integer,
                 Color2 Integer,
                 Color3 Integer,
                 Color4 Integer,
                 Color5 Integer,
                 Color6 Integer,
                 Color7 Integer
               )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbDowStart Integer;
  DECLARE vbLineCount Integer;
  DECLARE vbCount Integer;
  DECLARE vbIndex Integer;
  DECLARE vbLast Integer;
  DECLARE vbID Integer;
  DECLARE vbDow Integer;
  DECLARE vbValue TVarChar;
  DECLARE vbValuePlan TVarChar;
  DECLARE vbColor Integer;
  DECLARE vbUserValue TVarChar;
  DECLARE vbUserValuePlan TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   vbMovementId := 0;

    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                AND Movement.OperDate = DATE_TRUNC ('MONTH', CURRENT_DATE))
    THEN
       SELECT Movement.ID
       INTO vbMovementId
       FROM Movement
       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
         AND Movement.OperDate = DATE_TRUNC ('MONTH', CURRENT_DATE);
/*    ELSE
       vbMovementId := lpInsertUpdate_Movement_EmployeeSchedule (ioId          := 0
                                                               , inInvNumber       := CAST (NEXTVAL ('movement_EmployeeSchedule_seq')  AS TVarChar)
                                                               , inOperDate        := DATE_TRUNC ('MONTH', CURRENT_DATE)
                                                               , inUserId          := vbUserId
                                                                 );
*/
    END IF;

    IF COALESCE (vbMovementId, 0) <> 0 AND
       EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = vbUserId)
    THEN
      SELECT 
        COALESCE(MIString_ComingValueDayUser.ValueData, '0000000000000000000000000000000'),
        COALESCE(MIString_ComingValueDay.ValueData, '0000000000000000000000000000000')
      INTO 
        vbUserValue, 
        vbUserValuePlan
      FROM MovementItem

           LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                        ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                       AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

           LEFT JOIN MovementItemString AS MIString_ComingValueDay
                                        ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                       AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = vbUserId;
    ELSE
      vbUserValue := '0000000000000000000000000000000';
      vbUserValuePlan := '0000000000000000000000000000000';
    END IF;

     --
   CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
      SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', CURRENT_DATE), DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

   vbDowStart := (SELECT date_part('isodow', Min(OperDate)) FROM tmpOperDate);
   vbLineCount := CEIL((0.0 + vbDowStart + (SELECT COUNT(*) FROM tmpOperDate)) / 7);
   vbCount := (SELECT COUNT(*) FROM tmpOperDate);

    CREATE TEMP TABLE tmpValues (
                 Id Integer,
                 Range TVarChar,
                 Value1 TVarChar,
                 Value2 TVarChar,
                 Value3 TVarChar,
                 Value4 TVarChar,
                 Value5 TVarChar,
                 Value6 TVarChar,
                 Value7 TVarChar,
                 ValuePlan1 TVarChar,
                 ValuePlan2 TVarChar,
                 ValuePlan3 TVarChar,
                 ValuePlan4 TVarChar,
                 ValuePlan5 TVarChar,
                 ValuePlan6 TVarChar,
                 ValuePlan7 TVarChar,
                 Color1 Integer,
                 Color2 Integer,
                 Color3 Integer,
                 Color4 Integer,
                 Color5 Integer,
                 Color6 Integer,
                 Color7 Integer) ON COMMIT DROP;

    -- Заполняем строки таблицу
    vbIndex := 1;
    WHILE (vbIndex <= vbLineCount) LOOP
      INSERT INTO tmpValues (Id, Range,
                 Value1, Value2, Value3, Value4, Value5, Value6, Value7,
                 ValuePlan1, ValuePlan2, ValuePlan3, ValuePlan4, ValuePlan5, ValuePlan6, ValuePlan7,
                 Color1, Color2, Color3, Color4, Color5, Color6, Color7)
                 VALUES (vbIndex, '',
                 '', '', '', '', '', '', '',
                 '', '', '', '', '', '', '',
                 zc_Color_Greenl(), zc_Color_Greenl(), zc_Color_Greenl(), zc_Color_Greenl(), zc_Color_Greenl(), zc_Color_Greenl(), zc_Color_Greenl());
      vbIndex := vbIndex  + 1;
    END LOOP;

    vbIndex := 1;
    WHILE (vbIndex <= vbCount) LOOP
      vbID := CEIL((vbDowStart + vbIndex - 1.0) / 7);
      vbDow := Mod(vbDowStart + vbIndex - 2.0, 7) + 1;

--      raise notice 'vbDowStart: % vbID: % vbDow: %', vbDowStart, vbID, vbDow;

      vbValue := lpDecodeValueDay(vbIndex, vbUserValue);
      vbValuePlan := lpDecodeValueDay(vbIndex, vbUserValuePlan);

      IF vbIndex = date_part('day', CURRENT_DATE)
      THEN
        vbColor := zc_Color_Red();
      ELSE
        vbColor := zc_Color_White();
      END IF;


      IF vbDow = 1 OR vbIndex = 1
      THEN
        IF vbID = 1
        THEN
          vbLast := 8 - vbDowStart;
        ELSIF (vbIndex + 6) > vbCount
        THEN
          vbLast := vbCount;
        ELSE
          vbLast := vbIndex + 6;
        END IF;

        UPDATE tmpValues SET Range = 'c '||vbIndex::TVarChar||' по '||vbLast::TVarChar WHERE tmpValues.Id = vbID;
      END IF;

      IF vbDow = 1
      THEN
        UPDATE tmpValues SET Value1 = vbValue, ValuePlan1 = vbValuePlan, Color1 = vbColor WHERE tmpValues.Id = vbID;
      ELSIF vbDow = 2
      THEN
        UPDATE tmpValues SET Value2 = vbValue, ValuePlan2 = vbValuePlan, Color2 = vbColor WHERE tmpValues.Id = vbID;
      ELSIF vbDow = 3
      THEN
        UPDATE tmpValues SET Value3 = vbValue, ValuePlan3 = vbValuePlan, Color3 = vbColor WHERE tmpValues.Id = vbID;
      ELSIF vbDow = 4
      THEN
        UPDATE tmpValues SET Value4 = vbValue, ValuePlan4 = vbValuePlan, Color4 = vbColor WHERE tmpValues.Id = vbID;
      ELSIF vbDow = 5
      THEN
        UPDATE tmpValues SET Value5 = vbValue, ValuePlan5 = vbValuePlan, Color5 = vbColor WHERE tmpValues.Id = vbID;
      ELSIF vbDow = 6
      THEN
        UPDATE tmpValues SET Value6 = vbValue, ValuePlan6 = vbValuePlan, Color6 = vbColor WHERE tmpValues.Id = vbID;
      ELSE
        UPDATE tmpValues SET Value7 = vbValue, ValuePlan7 = vbValuePlan, Color7 = vbColor WHERE tmpValues.Id = vbID;
      END IF;

      vbIndex := vbIndex  + 1;
    END LOOP;

    RETURN QUERY
      SELECT * FROM tmpValues ORDER BY ID;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeSchedule_User (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.12.18                                                       *
*/

-- тест
-- select * from gpSelect_MovementItem_EmployeeSchedule_User(inSession := '308120');