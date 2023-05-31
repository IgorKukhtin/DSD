-- Function: gpBranchService_Ban_Changes_Trigger()

-- DROP FUNCTION _replica.gpBranchService_Ban_Changes_Trigger();

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Ban_Changes_Trigger()
  RETURNS trigger AS
$BODY$
   DECLARE current_row    RECORD;
   DECLARE vbUserSlaveUpd Text;
BEGIN
  IF (TG_OP ILIKE 'INSERT') OR (TG_OP ILIKE 'UPDATE') THEN
    current_row := NEW;
  ELSE
    current_row := OLD;
  END IF;
  
  SELECT UserSlaveUpd
  INTO vbUserSlaveUpd
  FROM _replica.gpBranchService_Select_MasterConnectParams('0');
  
  IF vbUserSlaveUpd ILIKE session_user
  THEN
    RETURN current_row;
  END IF;
  
  IF TG_TABLE_NAME ILIKE 'MovementItem%' AND TG_TABLE_NAME NOT ILIKE '%Desc' AND TG_TABLE_NAME NOT ILIKE '%Protocol' 
  THEN
    IF TG_TABLE_NAME ILIKE 'MovementItem' 
    THEN
      IF NOT EXISTS(SELECT RM.ID FROM _replica.BranchService_Reserve_Movement AS RM 
                    WHERE RM.Id = current_row.MovementId 
                      AND RM.DescId = 0)
      THEN
        RAISE EXCEPTION 'Изменение загруженных данных запрещено...';
      ELSEIF (TG_OP ILIKE 'INSERT') 
      THEN
         PERFORM _replica.lpBranchService_Get_MovementItemId (current_row.Id);
      ELSEIF NOT EXISTS(SELECT RM.ID FROM _replica.BranchService_Reserve_Movement AS RM 
                        WHERE RM.Id = current_row.Id 
                          AND RM.DescId = -1)
      THEN
        RAISE EXCEPTION 'Изменение загруженных данных запрещено...';
      END IF;
    ELSE
      IF NOT EXISTS(SELECT RM.ID FROM _replica.BranchService_Reserve_Movement AS RM 
                    WHERE RM.Id = current_row.MovementItemId 
                      AND RM.DescId = -1)
      THEN
        RAISE EXCEPTION 'Изменение загруженных данных запрещено...';
      END IF;    
    END IF;
  ELSEIF TG_TABLE_NAME ILIKE 'Movement%' AND TG_TABLE_NAME NOT ILIKE '%Desc' AND TG_TABLE_NAME NOT ILIKE '%Protocol'
  THEN
    IF TG_TABLE_NAME ILIKE 'Movement' 
    THEN
      IF (TG_OP ILIKE 'INSERT') 
      THEN
         PERFORM _replica.lpBranchService_Get_MovementId (current_row.DescId, current_row.Id, current_row.InvNumber);         
      ELSEIF NOT EXISTS(SELECT RM.ID FROM _replica.BranchService_Reserve_Movement AS RM 
                        WHERE RM.Id = current_row.Id 
                          AND RM.DescId = 0)
      THEN
        RAISE EXCEPTION 'Изменение загруженных данных запрещено...';
      --ELSEIF NEW.StatusId <> OLD.StatusId
      --THEN
      --  RAISE EXCEPTION 'Изменение статуса документа запрещено...';      
      END IF;
    ELSE
      IF NOT EXISTS(SELECT RM.ID FROM _replica.BranchService_Reserve_Movement AS RM 
                    WHERE RM.Id = current_row.MovementId 
                      AND RM.DescId = 0)
      THEN
        RAISE EXCEPTION 'Изменение загруженных данных запрещено...';
      END IF;    
    END IF;  
  ELSEIF TG_TABLE_NAME ILIKE 'Object%' AND TG_TABLE_NAME NOT ILIKE '%Protocol' AND TG_TABLE_NAME NOT ILIKE '%Desc' 
  THEN 
    IF TG_TABLE_NAME ILIKE 'Object' AND TG_TABLE_NAME NOT ILIKE 'ObjectHistory%' 
    THEN
      IF EXISTS(SELECT Object.ID FROM Object WHERE Object.Id = current_row.Id AND Object.DescId NOT IN 
                (zc_Object_UserFormSettings()))
      THEN
        RAISE EXCEPTION 'Изменение справочников и истории запрешено...';
      END IF;
    ELSEIF TG_TABLE_NAME ILIKE 'Object%' AND TG_TABLE_NAME NOT ILIKE 'ObjectHistory%' 
    THEN
      IF EXISTS(SELECT Object.ID FROM Object WHERE Object.Id = current_row.ObjectId AND Object.DescId NOT IN 
                (zc_Object_UserFormSettings()))
      THEN
        RAISE EXCEPTION 'Изменение справочников и истории запрешено...';
      END IF;    
    ELSE
      RAISE EXCEPTION 'Изменение справочников и истории запрешено...';
    END IF;  
  ELSEIF TG_TABLE_NAME NOT ILIKE '%Protocol'
  THEN
    RAISE EXCEPTION 'Изменение данных в таблице <%> запрещено...', TG_TABLE_NAME;  
  END IF;

  RETURN current_row;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.04.23                                                       * 
*/

-- Тест