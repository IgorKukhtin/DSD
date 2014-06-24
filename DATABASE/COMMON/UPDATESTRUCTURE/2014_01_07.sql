-- Поменять у документов табель учета рабочего времени Сотрудника на Физ. лицо
DO $$ 
    BEGIN
      IF EXISTS(Select * From INFORMATION_SCHEMA.tables WHERE TABLE_NAME = 'object_personal_view') THEN
         UPDATE MovementItem SET ObjectId = Object_Personal_View.MemberId
           FROM Movement, Object_Personal_View 
          WHERE Object_Personal_View.PersonalId = MovementItem.ObjectId 
            AND Movement.Id = MovementItem.MovementId 
            AND Movement.DescId = zc_Movement_SheetWorkTime() 
            AND MovementItem.DescId = zc_MI_Master();
      END IF;
    END;
$$;