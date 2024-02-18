<template>
  <div class="py-4 container-fluid">
    <div class="row">
      <div class="col-12">
        <requests-table />
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <projects-table />
      </div>
    </div>
  </div>
</template>

<script>
import RequestsTable from "./components/RequestsTable.vue";
import ProjectsTable from "./components/ProjectsTable.vue";

export default {
  name: "RequestsPage",
  components: {
    RequestsTable,
    ProjectsTable,
  },
};
</script>
