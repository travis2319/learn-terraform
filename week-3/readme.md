# Variable Syntax

## Basic Syntax

```hcl
variable "<variable_name>" {
  description = "Description of the variable"
  type        = <type>
  default     = <default_value>  # optional
}
```

---

## Example

![alt text](assets/variable-eg.png)

# Output Syntax

## Basic Syntax

```hcl
output "<output_name>" {
  description = "Description of the output"
  value       = <expression>
}
```

---

## Example
![alt text](assets/output-eg.png)

# meta arguments
![alt text](assets/meta-arguments-eg.png)
