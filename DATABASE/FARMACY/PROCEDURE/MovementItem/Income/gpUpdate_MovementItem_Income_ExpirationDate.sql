DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_ExpirationDate(Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_ExpirationDate(
    IN inMovementItemId      Integer   , -- строка документа
    IN inMovementId          Integer   , -- документ
    IN inJuridicalId         Integer   , -- Поставщик
    IN inExpirationDate      TDateTime , -- Срок годности
   OUT outExpirationDate     TDateTime , -- Срок годности
   OUT outExpirationDatePD   TDateTime , -- Срок годности
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

--    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
--              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
--    THEN
--      RAISE EXCEPTION 'Ошибка. У вас нет прав выполнять эту операцию.';     
--    END IF;     

    -- определяется
    SELECT 
        StatusId
      , InvNumber 
    INTO 
        vbStatusId
      , vbInvNumber   
    FROM 
        Movement 
    WHERE
        Id = inMovementId;
         
    IF NOT EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_ChangeExpirationDate
                  WHERE ObjectBoolean_ChangeExpirationDate.ObjectId = inJuridicalId
                    AND ObjectBoolean_ChangeExpirationDate.DescId = zc_ObjectBoolean_Juridical_ChangeExpirationDate()
                    AND ObjectBoolean_ChangeExpirationDate.ValueData = TRUE)
    THEN
        RAISE EXCEPTION 'Ошибка. По поставщику запрещено изменять срок годности.';
    END IF;


    IF vbStatusId = zc_Enum_Status_Complete() AND 
       EXISTS(SELECT 1 
              FROM  MovementItemContainer AS MIC

                    INNER JOIN Container AS ContainerPD
                                         ON ContainerPD.ParentId = MIC.ContainerId
                                        AND ContainerPD.DescId = zc_Container_CountPartionDate()

              WHERE MIC.MovementId = inMovementId
                AND MIC.MovementItemId = inMovementItemId
                AND MIC.DescId = zc_MIContainer_Count())
    THEN
        IF (SELECT count(*)
            FROM  MovementItemContainer AS MIC

                  INNER JOIN Container AS ContainerPD
                                       ON ContainerPD.ParentId = MIC.ContainerId
                                      AND ContainerPD.DescId = zc_Container_CountPartionDate()

            WHERE MIC.MovementId = inMovementId
              AND MIC.MovementItemId = inMovementItemId
              AND MIC.DescId = zc_MIContainer_Count()) > 1
        THEN
           RAISE EXCEPTION 'Ошибка. По партии было более одного изменения срока.';        
        END IF;
        
        IF (SELECT ObjectDate_ExpirationDate.ValueData
            FROM  MovementItemContainer AS MIC

                  INNER JOIN Container AS ContainerPD
                                       ON ContainerPD.ParentId = MIC.ContainerId
                                      AND ContainerPD.DescId = zc_Container_CountPartionDate()

                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = ContainerPD.ID
                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                  LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                       ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                                      AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

            WHERE MIC.MovementId = inMovementId
              AND MIC.MovementItemId = inMovementItemId
              AND MIC.DescId = zc_MIContainer_Count()) = 
           (SELECT MIDate_ExpirationDate.ValueData 
            FROM MovementItemDate AS MIDate_ExpirationDate
            WHERE MIDate_ExpirationDate.MovementItemId = inMovementItemId
              AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods())
        THEN
            PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), ObjectDate_ExpirationDate.ObjectId, inExpirationDate)
            FROM  MovementItemContainer AS MIC

                  INNER JOIN Container AS ContainerPD
                                       ON ContainerPD.ParentId = MIC.ContainerId
                                      AND ContainerPD.DescId = zc_Container_CountPartionDate()

                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = ContainerPD.ID
                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                  LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                       ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                                      AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

            WHERE MIC.MovementId = inMovementId
              AND MIC.MovementItemId = inMovementItemId
              AND MIC.DescId = zc_MIContainer_Count();        
            outExpirationDatePD := inExpirationDate;
        ELSE
           RAISE EXCEPTION 'Ошибка. По партии уже изменен срок.';        
        END IF;
        
    ELSE
        -- Сохранили <Срок годности>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inMovementItemId, inExpirationDate);
        outExpirationDate := inExpirationDate;
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.07.21                                                       *
*/

-- select * from gpUpdate_MovementItem_Income_ExpirationDate(inMovementItemId := 449805652 , inMovementId := 24472940 , inJuridicalId := 17434172 , inExpirationDate := ('01.01.2022')::TDateTime ,  inSession := '3');