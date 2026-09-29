source("Library.R")

# Read in Literature data ----

readxl::read_excel("Data/Literature data.xlsx") -> literature_data_df

## Cleaning data ----

string_remover <- "https://iopscience.iop.org/article/|https://link.springer.com/article/|pdf|DOI:| |DOI: |doi:|https://www.science.org/doi/|https://agupubs.onlinelibrary.wiley.com/doi/full/|doi.org/|http://dx.doi.org/|https://doi.org/"

# Retrieve data from doi ----

literature_data_df %>% 
  select(Publication_DOI) %>% 
  mutate(Publication_DOI = str_remove_all(Publication_DOI, string_remover),
         row = row_number()) %>% 
  drop_na() %>% 
  filter(!Publication_DOI %in% c("N/A","NA")) %>% 
  mutate(data = lapply(Publication_DOI, cr_works)) %>%  # Check https://github.com/CrossRef/rest-api-doc for cr_works 
  unnest_wider(data) -> doi_meta_df
  
# Combine them ----

literature_data_df %>% 
  select(Gender:Publication_Year) %>% 
  mutate(Publication_DOI = str_remove_all(Publication_DOI, string_remover),
         row = row_number()) %>% 
  full_join(doi_meta_df) %>% 
  unnest() %>% 
  remove_empty() %>% 
  write_csv("Output/crossref.csv")

# Just plotting around with data ----

literature_data_df %>% 
  select(Gender:Publication_Year) %>% 
  mutate(Publication_DOI = str_remove_all(Publication_DOI, string_remover),
         row = row_number()) %>% 
  full_join(doi_meta_df) %>% 
  mutate(Publication_Year = parse_integer(Publication_Year),
         Career_Years = case_when(Career_Years == 7 ~ "6-10",
                                  T ~ Career_Years),
         Career_Years = factor(Career_Years, levels = c("1-5","6-10","11-20","21-30",">30"))) %>% 
  unnest_wider(data) -> plot_df
  
plot_df %>% 
  drop_na(Career_Years) %>% 
  ggplot(aes(Career_Years, Publication_Year)) + 
  geom_jitter(width = 0.1)

plot_df %>% 
  mutate(is.referenced.by.count = parse_integer(is.referenced.by.count)) %>% 
  ggplot(aes(Publication_Year, is.referenced.by.count)) + 
  geom_point()


