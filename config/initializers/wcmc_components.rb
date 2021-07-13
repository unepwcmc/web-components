#require 'wcmc_table'

WcmcComponents.routes_classes = {'/countries/' => 'Country',
                        '/meas/' => 'Mea'}
WcmcComponents.classes_show_page_format = {'Country' => '/country/%d/',
                                           'Mea' => '/moreComplicated/%d/format'}
