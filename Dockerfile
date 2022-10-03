#base AppScan Source container 
FROM hclcr.io/appscan/appscan-src-cli:10.0.8

#switch to ROOT 
USER root

# Run scripts
CMD [""]
ENTRYPOINT ["/appscansource/bin/entrypoint.sh"]
