resource "google_pubsub_schema" "VerifySchema" {
  name       = "VerifySchema"
  type       = "AVRO"
  definition = <<JSON
{
  "type": "record",
  "name": "Avro",
  "fields": [
    {
      "name": "username",
      "type": "string"
    }
  ]
}
JSON
}

resource "google_pubsub_topic" "verifyUser" {
  name       = "verify_email"
  depends_on = [google_pubsub_schema.VerifySchema]
  schema_settings {
    schema   = var.verify_schema
    encoding = "JSON"
  }
  message_retention_duration = "604800s"
}
