-- Run against an existing database to enable image-only exercise media.
ALTER TABLE public.exercise
    ALTER COLUMN video_path DROP NOT NULL;

ALTER TABLE public.exercise
    ADD COLUMN IF NOT EXISTS image_path TEXT;

UPDATE storage.buckets
SET allowed_mime_types = ARRAY['video/*', 'image/png', 'image/jpeg', 'image/gif']
WHERE id = 'exercise-videos';
