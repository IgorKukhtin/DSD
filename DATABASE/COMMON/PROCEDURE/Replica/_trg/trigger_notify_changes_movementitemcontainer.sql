-- Trigger: trigger_notify_changes_movementitemcontainer on public.movementitemcontainer

DROP TRIGGER IF EXISTS trigger_notify_changes_movementitemcontainer ON public.movementitemcontainer;

CREATE TRIGGER trigger_notify_changes_movementitemcontainer
  BEFORE INSERT OR UPDATE OR DELETE
  ON public.movementitemcontainer
  FOR EACH ROW
  EXECUTE PROCEDURE _replica.notice_changed_data_movementitemcontainer();
