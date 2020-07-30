-- Trigger: trigger_notify_changes_movement on public.movement

DROP TRIGGER IF EXISTS trigger_notify_changes_movement ON public.movement;

CREATE TRIGGER trigger_notify_changes_movement
  BEFORE INSERT OR UPDATE OR DELETE
  ON public.movement
  FOR EACH ROW
  EXECUTE PROCEDURE _replica.notice_changed_data_movement();
