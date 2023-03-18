variable "input_maps" {
  description = "The list of maps to merge."
  type        = any
}

variable "expected_output" {
  description = "The expected output map."
  type        = any
}

variable "test_key" {
  description = "A unique identifier for this test."
  type        = any
}
