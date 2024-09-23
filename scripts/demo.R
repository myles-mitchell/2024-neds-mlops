library("ggplot2")
library("palmerpenguins")
library("tidymodels")

# Tidy the data
penguins_data = tidyr::drop_na(penguins, flipper_length_mm)

# Visualise the data
ggplot(penguins_data, aes(flipper_length_mm, body_mass_g)) +
  geom_point(aes(colour = species, shape = island)) +
  theme_minimal() +
  xlab("Flipper Length(mm)") +
  ylab("Body Mass(g)") +
  viridis::scale_colour_viridis(discrete = TRUE)

# Set up the model recipe
model = recipe(
  species ~ island + flipper_length_mm + body_mass_g,
  data = penguins_data
) |>
  workflow(nearest_neighbor(mode = "classification")) |>
  fit(penguins_data)

# Make predictions using the model
model_pred = predict(model, penguins_data)
mean(
  model_pred$.pred_class == as.character(
    penguins_data$species
  )
)

# Create a Vetiver model
v_model = vetiver::vetiver_model(model,
                                 model_name = "k-nn",
                                 description = "blog-test")
v_model

# Examine Vetiver model
names(v_model)
v_model$description
v_model$metadata

# Deploy model locally
plumber::pr() |>
  vetiver::vetiver_api(v_model) |>
  plumber::pr_run()

# (in a new console) Check the local deployment
base_url = "127.0.0.1:5259/"
url = paste0(base_url, "ping")
r = httr::GET(url)
metadata = httr::content(r, as = "text", encoding = "UTF-8")
jsonlite::fromJSON(metadata)

# Predict with deployed model
url = paste0(base_url, "predict")
endpoint = vetiver::vetiver_endpoint(url)
pred_data = penguins_data |>
  dplyr::select(
    "island", "flipper_length_mm", "body_mass_g"
  ) |>
  dplyr::slice_sample(n = 10)
predict(endpoint, pred_data)
